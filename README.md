# Ansible & Terraform Learning Labs

Repositori ini berisi kumpulan materi praktikum dan latihan untuk mempelajari **Ansible** (Configuration Management) dan **Terraform** (Infrastructure as Code) menggunakan VM GCP.

---

## 🛠️ Persiapan Awal (Prerequisites)

### 1. Kloning & Pengaturan Environment Variables
Di root project, salin template `.env.example` ke `.env` untuk menyimpan konfigurasi IP target dan kredensial secara global:
```bash
cp .env.example .env
```
Edit file `.env` dan isi variabel yang dibutuhkan. Kemudian muat variabel tersebut ke terminal session:
```bash
export $(cat .env | xargs)
```

### 2. Instalasi Tools Lokal
Pastikan tools berikut sudah terinstal di komputer lokal Anda:

#### **Terraform**
```bash
# Tambahkan repositori HashiCorp & instal
sudo apt update && sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
```

#### **Google Cloud CLI (gcloud)**
```bash
# Tambahkan repositori Google Cloud & instal
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update && sudo apt install -y google-cloud-cli
```
*Inisialisasi akun GCP Anda:*
```bash
gcloud init
gcloud auth application-default login
```

#### **Java 17 JDK (PENTING)**
*Proyek ini menggunakan Gradle 7.3.1 yang **hanya mendukung maksimal Java 17**. Jangan menggunakan default-jdk (Java 21) karena akan menyebabkan build error.*
```bash
sudo apt update && sudo apt install -y openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

#### **Ansible**
```bash
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
```

---

## 🚀 Panduan Eksekusi & Uji Coba (Sample & Exercise)

Semua playbook dijalankan merujuk ke **Dynamic Inventory** [**`exercise1/inventory.py`**](file:///home/dimas/ansible-terraform-learning-labs/exercise1/inventory.py) agar IP target otomatis dibaca dari file `.env`.

---

### **Exercise 3: Provisioning 2 VM GCP (Langkah Pertama)**
Membuat **2 VM Instance (`web1` dan `web2`)** secara otomatis di GCP beserta konfigurasi firewall dan injeksi SSH Key.
* **Cara Menjalankan:**
  ```bash
  cd exercise3
  # Buat file terraform.tfvars dan masukkan: gcp_project = "project-id-anda"
  terraform init
  terraform apply
  ```
* **Cara Cek Keberhasilan:**
  Setelah sukses, IP publik kedua VM akan muncul sebagai output (`web1_public_ip` dan `web2_public_ip`). Masukkan IP tersebut ke dalam `.env` di root folder.

---

### **Exercise 1: Uji Koneksi Awal (Ping)**
Memverifikasi koneksi Ansible ke kedua VM GCP target.
* **Cara Menjalankan:**
  ```bash
  ansible all -i exercise1/inventory.py -m ping
  ```
* **Cara Cek Keberhasilan:**
  Output terminal berwarna hijau dengan pesan `"ping": "pong"` untuk masing-masing `web1` dan `web2`.

---

### **Code Sample 2: Playbooks (Apache di `web1`)**
Menginstal dan mengaktifkan Apache Web Server di VM `web1`.
* **Cara Menjalankan:**
  ```bash
  cd sample2
  ansible-playbook -i ../exercise1/inventory.py playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  ```bash
  curl http://$WEB1_IP
  ```
  *(Menampilkan kode HTML dari halaman default Apache)*

---

### **Code Sample 3: Handlers (Apache dengan trigger Restart)**
Menginstal Apache dan merestart server hanya jika file konfigurasi mengalami perubahan.
* **Cara Menjalankan:**
  ```bash
  cd sample3
  touch foo.conf
  ansible-playbook -i ../exercise1/inventory.py playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  Buka/akses `curl http://$WEB1_IP` dan cek syslog di server target untuk melihat log restart jika `foo.conf` diubah lalu dijalankan ulang.

---

### **Code Sample 4: Variables**
Mempelajari penggunaan variabel dinamis di Ansible.
* **Cara Menjalankan:**
  ```bash
  cd sample4
  ansible-playbook -i ../exercise1/inventory.py playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  Periksa output terminal untuk memastikan variabel dideklarasikan dan dicetak dengan benar oleh task Ansible.

---

### **Code Sample 5: Deployment Hazelcast & Calculator (2 VM)**
Mendeploy Hazelcast Server di `web1` dan Calculator Service di `web2`.
* **Cara Menjalankan:**
  ```bash
  cd sample5
  # Build proyek Java (Memerlukan Java 17)
  ./gradlew build
  # Jalankan playbook
  ansible-playbook -i ../exercise1/inventory.py playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  ```bash
  curl "http://$WEB2_IP:8080/sum?a=10&b=20"
  ```
  *(Output yang diharapkan mengembalikan hasil: **`30`**)*

---

### **Code Sample 6: Ansible Docker Playbook (Hazelcast Container)**
Menginstal Docker CE di server target dan menjalankan container Hazelcast.
* **Cara Menjalankan:**
  ```bash
  cd sample6
  ansible-playbook -i ../exercise1/inventory.py install-docker-playbook.yml
  ansible-playbook -i ../exercise1/inventory.py hazelcast-playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  ```bash
  ssh ubuntu@$WEB1_IP "sudo docker ps"
  ```
  *(Output menampilkan container `hazelcast/hazelcast` berstatus Running)*

---

### **Exercise 2: Deploy Flask Hello World Service**
Mendeploy aplikasi Flask Python sebagai System Service di VM `web1`.
* **Cara Menjalankan:**
  ```bash
  cd exercise2
  ansible-playbook -i ../exercise1/inventory.py playbook.yml
  ```
* **Cara Cek Keberhasilan:**
  ```bash
  curl http://$WEB1_IP:5000/hello
  ```
  *(Output yang diharapkan mengembalikan string: **`Hello World!`**)*

---

### **Code Sample 7: AWS Terraform Lab (LocalStack Sandbox)**
Mempelajari cara provisioning resources AWS EC2 secara lokal gratis menggunakan simulator LocalStack (tanpa perlu mendaftar/mengaktifkan akun AWS asli).
* **Prerequisites Tambahan (Menjalankan LocalStack):**
  Pastikan LocalStack sudah terpasang dan berjalan sebagai Docker container di komputer lokal Anda:
  ```bash
  docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack
  ```
* **Cara Menjalankan:**
  ```bash
  cd sample7/aws-teraform-lab
  terraform init
  terraform apply
  ```
* **Cara Cek Keberhasilan:**
  ```bash
  aws --endpoint-url=http://localhost:4566 ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,Tags]"
  ```
  *(Menampilkan rincian EC2 Instance tiruan `Praktikum-Instance` yang berhasil dibuat secara lokal)*

