# 🟩 Contribution-stat

Auto-commit bot untuk mengisi GitHub contribution graph secara otomatis.

---

## ✨ Fitur

- Backfill contribution dari **1 Januari 2025** sampai hari ini
- **5–12 commit per hari** dengan pola acak yang natural
- Jam commit tersebar acak antara jam 07.00–22.00
- Weekday lebih aktif dari weekend
- Pesan commit bervariasi (conventional commits + emoji)
- GitHub Actions untuk auto commit harian ke depannya

---

## 🚀 Cara Pakai

### Prasyarat
- [Git for Windows](https://git-scm.com/download/win) (sudah include Git Bash)
- [Python 3](https://python.org) (untuk kalkulasi tanggal)
- Akun GitHub

---

### 1. Fork atau clone repo ini

```bash
git clone https://github.com/aditrachman/Contribution-stat.git
cd Contribution-stat
```

### 2. Set email Git sesuai akun GitHub kamu

> ⚠️ Email **harus sama persis** dengan email yang terdaftar di akun GitHub, atau contribution tidak akan terhitung.

```bash
git config --global user.email "emailkamu@gmail.com"
git config --global user.name "usernamekamu"
```

### 3. Reset repo (kalau mau mulai dari nol)

Di PowerShell:
```powershell
git update-ref -d HEAD
git rm -rf .
```

### 4. Jalankan script backfill

Buka **Git Bash** di folder repo (klik kanan → Git Bash Here), lalu:

```bash
git config core.autocrlf false
bash backfill.sh
```

Tunggu sampai muncul:
```
✅ SELESAI!
```

### 5. Push ke GitHub

```bash
git push origin main --force
```

Buka profile GitHub kamu — contribution graph langsung hijau dari Januari 2025! 🟩

---

## 🔄 Setup GitHub Actions (Auto Commit Harian)

Agar commit berjalan otomatis setiap hari tanpa perlu melakukan apapun:

### 1. Aktifkan Write Permission

> ⚠️ Langkah ini wajib, tanpa ini Actions tidak bisa push commit.

1. Buka repo di GitHub
2. **Settings** → **Actions** → **General**
3. Scroll ke **Workflow permissions**
4. Pilih **Read and write permissions** ✅
5. Klik **Save**

### 2. Pastikan Actions aktif

> Settings → Actions → General → Allow all actions ✅

### 3. Cek di tab Actions

Buka tab **Actions** di repo — workflow `Auto Commit Daily` akan jalan otomatis **6x sehari** sesuai jadwal. Tidak perlu melakukan apapun lagi.

---

## 📅 Mau Isi Hari Ini Manual?

Kalau mau nambah commit untuk hari ini saja, jalankan di Git Bash:

```bash
d=$(date '+%Y-%m-%dT%H:%M:%S')
echo "$d" > LAST_UPDATED
git add -A
git commit -m "chore(bot): 🟩 auto commit"
git push origin main
```

---

## 🗓️ Mau Backfill Ulang di Masa Depan?

Misalnya beberapa bulan ke depan kamu mau extend periodenya, tinggal:

1. Edit baris `start = date(2025, 1, 1)` di `backfill.sh` sesuai tanggal yang diinginkan
2. Reset repo
3. Jalankan `bash backfill.sh` lagi
4. `git push origin main --force`

---

## ⚙️ Kustomisasi

Edit bagian ini di `backfill.sh` sesuai kebutuhan:

| Bagian | Lokasi di script | Default |
|--------|-----------------|---------|
| Tanggal mulai | `start = date(2025, 1, 1)` | 1 Jan 2025 |
| Commit weekday | `RANDOM % 8 + 5` | 5–12/hari |
| Commit weekend | `RANDOM % 5 + 5` | 5–9/hari |
| Jam commit | `RANDOM % 16 + 7` | 07.00–22.00 |

---

## ❓ Troubleshooting

**Contribution tidak muncul di profile?**
- Pastikan repo **Public**
- Pastikan email git sama dengan email GitHub
- Tunggu ~15 menit setelah push, GitHub butuh waktu update

**Error `Permission denied 403` di Actions?**
- Settings → Actions → General → Workflow permissions → **Read and write permissions** ✅

**Error `integer expression expected`?**
```bash
git config core.autocrlf false
```
Lalu jalankan ulang script.

**Git Bash tidak ada?**
Download dan install [Git for Windows](https://git-scm.com/download/win).

---

## 📄 Lisensi

MIT — bebas dipakai dan dimodifikasi.