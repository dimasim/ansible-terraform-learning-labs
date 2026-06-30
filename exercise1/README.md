# Exercise 1: Membuat Infrastruktur Server & Mengelolanya dengan Ansible

Latihan ini memandu Anda dalam menyiapkan server target (VirtualBox/VM/Cloud) dan memastikan Ansible dapat mengelolanya secara remote.

## Langkah-Langkah

### I. Menyiapkan Mesin Virtual (VirtualBox / Vagrant)
1. Buat 2 Mesin Virtual (VM) menggunakan VirtualBox (atau provider cloud seperti AWS/GCP).
2. Gunakan OS Ubuntu Server (versi LTS disarankan).
3. Pastikan konfigurasi Network VM diatur ke **Bridged Adapter** atau **Host-Only Adapter** agar host utama dan VM saling terhubung dan mendapatkan IP address masing-masing.

---

### II. Konfigurasi Akses SSH (SSH Key-Based Authentication)
Agar Ansible dapat masuk ke target server tanpa meminta password, konfigurasikan SSH Key.

1. Di komputer utama Anda, buat SSH Key (jika belum ada):
   ```bash
   ssh-keygen -t rsa -b 4096
   ```
2. Salin SSH Key publik ke masing-masing server target:
   ```bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub user@<ip-server-1>
   ssh-copy-id -i ~/.ssh/id_rsa.pub user@<ip-server-2>
   ```
3. Uji coba koneksi SSH manual untuk memastikan tidak diminta password lagi:
   ```bash
   ssh user@<ip-server-1>
   ```

---

### III. Instalasi Python pada Mesin Jarak Jauh (Remote)
Ansible membutuhkan runtime Python pada server target untuk mengeksekusi modul-modulnya.

Masuk ke masing-masing server target (via SSH) dan jalankan:
```bash
sudo apt update
sudo apt install -y python3
```

---

### IV. Konfigurasi Inventaris Ansible (Inventory)
Pindahkan/sesuaikan konfigurasi IP dan user ke file [**`inventory.ini`**](file:///home/dimas/ansible-terraform-learning-labs/exercise1/inventory.ini) yang ada di folder ini:

```ini
[webservers]
web1 ansible_host=<IP_SERVER_1> ansible_user=<USER_SERVER_1>
web2 ansible_host=<IP_SERVER_2> ansible_user=<USER_SERVER_2>
```

---

### V. Jalankan Perintah Ansible Ad-Hoc (Ping)
Verifikasi bahwa seluruh infrastruktur telah terkonfigurasi dengan benar menggunakan modul ping:

```bash
ansible all -i inventory.ini -m ping
```

Jika sukses, Anda akan melihat output hijau/sukses berisi `"ping": "pong"` dari setiap host.
