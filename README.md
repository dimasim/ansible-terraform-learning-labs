# Ansible & Terraform Learning Labs

Repositori ini berisi kumpulan materi praktikum dan latihan untuk mempelajari **Ansible** (Configuration Management) dan **Terraform** (Infrastructure as Code).

## Persiapan Global (Environment Variables)

Untuk memudahkan pengelolaan kredensial dan IP target di seluruh sample dan exercise, Anda dapat menggunakan file [**`.env`**](file:///home/dimas/ansible-terraform-learning-labs/.env) di root project.

1. Salin template `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```
2. Buka dan edit file `.env` untuk memasukkan kredensial AWS, GCP Project ID, serta IP target server Anda.
3. Muat environment variables tersebut ke session terminal Anda sebelum menjalankan Terraform atau Ansible:
   ```bash
   export $(cat .env | xargs)
   ```

---

## Code Samples

### Code Sample 1: Ad hoc commands
Uji konektivitas Ansible ke mesin target menggunakan modul ad-hoc `ping`.
```bash
ansible all -m ping
```

### Code Sample 2: Playbooks
Menerapkan Playbook sederhana untuk menginstal dan menjalankan `apache2` pada host `web1` (lihat folder [sample2](sample2)).
```bash
ansible-playbook playbook.yml
```

### Code Sample 3: Handlers
Menggunakan *handler* untuk merestart `apache2` hanya ketika file konfigurasi berubah (lihat folder [sample3](sample3)).
```bash
touch foo.conf
ansible-playbook playbook.yml
```

### Code Sample 4: Variables
Mempelajari penggunaan variabel dinamis di Ansible Playbook (lihat folder [sample4](sample4)).
```bash
ansible-playbook playbook.yml
```

### Code Sample 5: Deployment dengan Ansible
Mendeploy aplikasi Hazelcast server di `web1` dan Calculator service di `web2` yang saling terhubung (lihat folder [sample5](sample5)).
```bash
./gradlew build
ansible-playbook playbook.yml
```

### Code Sample 6: Ansible Docker playbook
Menginstal Docker CE di remote server dan menjalankan container Hazelcast menggunakan modul Docker Ansible (lihat folder [sample6](sample6)).
```bash
ansible-playbook install-docker-playbook.yml
ansible-playbook hazelcast-playbook.yml
```

### Code Sample 7: Terraform AWS EC2
Provisioning EC2 instance `t2.micro` di AWS (lihat folder [sample7](sample7)).
```bash
cd sample7
terraform init
terraform plan
terraform apply
```

---

## Latihan (Exercise)

### Exercise 1: Menyiapkan Infrastruktur Server & Ansible Inventory
Panduan lengkap untuk setup VM lokal/cloud, konfigurasi akses SSH Key-Based, instalasi Python, dan pengaturan inventory Ansible.
* **Panduan lengkap ada di**: [**`exercise1/README.md`**](file:///home/dimas/ansible-terraform-learning-labs/exercise1/README.md)

### Exercise 2: Deploy Flask Hello World Web Service
Mendeploy web service berbasis Flask Python sebagai system service di host `web1` (lihat folder [exercise2](exercise2)).
```bash
ansible-playbook playbook.yml
```

### Exercise 3: Provisioning 2 VM GCP dengan Terraform (Integrasi Ansible)
Membuat **2 VM Instance (`web1` dan `web2`)** secara otomatis di GCP beserta konfigurasi firewall dan injeksi SSH Key agar siap dikonfigurasi dengan Ansible (lihat folder [exercise3](exercise3)).
1. Pastikan Anda sudah login menggunakan Google Cloud CLI:
   ```bash
   gcloud auth application-default login
   ```
2. Buat file `terraform.tfvars` di dalam folder `exercise3` lalu definisikan Project ID GCP Anda:
   ```hcl
   gcp_project = "id-project-gcp-anda"
   ```
3. Jalankan Terraform:
   ```bash
   cd exercise3
   terraform init
   terraform apply
   ```
4. Masukkan IP output (`web1_public_ip` & `web2_public_ip`) ke file `exercise1/inventory.ini` atau `.env`.
