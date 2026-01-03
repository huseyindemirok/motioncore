# Emülatör Açma Rehberi

## 🚀 Yöntem 1: Terminal'den (Hızlı)

```bash
# Android SDK path'ini ekle
export PATH="$HOME/Library/Android/sdk/emulator:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"

# Emülatörü başlat
emulator -avd Pixel_3a_API_36 -gpu host -memory 2048 -no-audio -no-boot-anim &
```

## 🎯 Yöntem 2: Android Studio'dan

1. **Android Studio'yu aç**
2. **Tools** → **Device Manager** (veya üst menüden)
3. **Pixel_3a_API_36** emülatörünü bul
4. **▶️ Play** butonuna tıkla

## 📱 Yöntem 3: Flutter'dan Direkt

```bash
# Flutter ile emülatör listesi
flutter emulators

# Belirli emülatörü başlat
flutter emulators --launch Pixel_3a_API_36
```

## ⚡ Yöntem 4: Hızlı Komut (Script)

Terminal'de şu komutu çalıştır:

```bash
cd ~/Desktop/MotionCore && export PATH="$HOME/Library/Android/sdk/emulator:$PATH" && export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH" && emulator -avd Pixel_3a_API_36 -gpu host -memory 1536 -no-audio -no-boot-anim &
```

## 🔍 Emülatör Durumunu Kontrol Et

```bash
# Bağlı cihazları göster
adb devices

# Emülatör çalışıyorsa "emulator-5554	device" görünür
```

## 🛠️ Sorun Giderme

### Emülatör açılmıyorsa:
1. Android Studio'yu aç
2. Tools → Device Manager
3. Emülatörü oradan başlat

### "command not found" hatası:
```bash
# Path'i kontrol et
echo $ANDROID_HOME

# Path'i ekle (bash için)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

### Emülatör çok yavaşsa:
- Memory'yi azalt: `-memory 1536` (2048 yerine)
- GPU acceleration kullan: `-gpu host`
- Audio'yu kapat: `-no-audio`

## 📝 Notlar

- Emülatör ilk açılışta 20-30 saniye sürebilir
- Açıldıktan sonra `adb devices` ile kontrol edin
- Flutter uygulaması: `flutter run -d emulator-5554`

