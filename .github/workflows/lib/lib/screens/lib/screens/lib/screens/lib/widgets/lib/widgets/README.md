# 🎬 Nella Editor

แอปตัดต่อวิดีโอบนมือถือ สีดำ-ขาว เรียบหรู ตัดต่อได้อย่างมืออาชีพ

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.22.0-blue)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

---

## ✨ ฟังก์ชันหลัก

| หมวดหมู่ | ฟังก์ชัน |
|---------|----------|
| 🎬 ตัดต่อวิดีโอ | Trim, Split, Crop, Rotate, Speed Ramp |
| 📝 ข้อความ | เพิ่มข้อความ, เปลี่ยนฟอนต์, สี, อนิเมชัน |
| 🎵 เสียง | ปรับระดับเสียง, Fade, Ducking, อัดเสียงพากย์ |
| 🎨 เอฟเฟกต์ | Blur, Glitch, VHS, Film Grain |
| 🎚️ Timeline | Multi-track, ซูม, Snap, Magnetic |
| 💾 ส่งออก | 480p ถึง 4K, H.264/H.265, ปรับ Bitrate |
| 🤖 AI | (เร็วๆนี้) Subtitle อัตโนมัติ, ลบพื้นหลัง |

---

## 📱 การติดตั้ง

### ดาวน์โหลด APK
1. ไปที่ **Actions** tab ใน GitHub Repo นี้
2. เลือก workflow ล่าสุดที่สำเร็จ (สีเขียว)
3. ดาวน์โหลด `nella-editor.apk`
4. ติดตั้งในมือถือ Android (อนุญาตติดตั้งจากแหล่งภายนอก)

### หรือ Build เอง
```bash
git clone https://github.com/pakornborvornkiattiwong-max/Nella.git
cd Nella
flutter pub get
flutter build apk --release
