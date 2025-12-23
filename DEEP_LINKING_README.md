# Deep Linking - Catálogos Compartibles

## Configuración Completa ✅

### 1. Rutas Configuradas

- **Ruta pública**: `/catalogo/:catalogId`
- **Sin autenticación requerida**: Los usuarios pueden ver catálogos públicos sin iniciar sesión
- **Deep Link Scheme**: `katalog://catalogo/{catalogId}`
- **Universal Link**: `https://tudominio.com/catalogo/{catalogId}` (reemplazar con tu dominio)

### 2. Android - AndroidManifest.xml

Ya configurado en: `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Deep Link para catálogos públicos -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="tudominio.com"
        android:pathPrefix="/catalogo" />
</intent-filter>

<!-- App Link Scheme personalizado (para testing) -->
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="katalog"
        android:host="catalogo" />
</intent-filter>
```

### 3. iOS - Info.plist

Agrega esto a `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.tuapp.katalog</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>katalog</string>
        </array>
    </dict>
</array>

<!-- Universal Links -->
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:tudominio.com</string>
</array>
```

### 4. Cómo Funciona

#### A. Desde la App (Botón Compartir)

1. Ve a "Mis Catálogos"
2. Abre un catálogo público
3. Presiona el botón de compartir (ícono compartir en blanco)
4. Se genera el enlace: `katalog://catalogo/{id}`

#### B. Abrir el Enlace

**Opción 1: Scheme personalizado (para testing)**
```
katalog://catalogo/693b0234c700d33f23518895
```

**Opción 2: Universal Link (producción)**
```
https://tudominio.com/catalogo/693b0234c700d33f23518895
```

### 5. Testing

#### Android (usando adb)
```bash
# Testing con scheme personalizado
adb shell am start -W -a android.intent.action.VIEW -d "katalog://catalogo/693b0234c700d33f23518895" com.tuapp.katalog

# Testing con URL
adb shell am start -W -a android.intent.action.VIEW -d "https://tudominio.com/catalogo/693b0234c700d33f23518895" com.tuapp.katalog
```

#### iOS (usando xcrun)
```bash
# Con simulador abierto
xcrun simctl openurl booted "katalog://catalogo/693b0234c700d33f23518895"
```

### 6. Configuración de Dominio (Para Universal Links)

#### Para Android (Digital Asset Links)
Crea un archivo en:
`https://tudominio.com/.well-known/assetlinks.json`

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.tuapp.katalog",
    "sha256_cert_fingerprints": ["TU_SHA256_FINGERPRINT"]
  }
}]
```

Obtén el SHA256 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Para iOS (Apple App Site Association)
Crea un archivo en:
`https://tudominio.com/.well-known/apple-app-site-association`

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.tuapp.katalog",
        "paths": ["/catalogo/*"]
      }
    ]
  }
}
```

### 7. Próximos Pasos

1. **Reemplazar "tudominio.com"** con tu dominio real en:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`
   - `lib/feature/catalog/view/catalog_detail_page.dart`

2. **Configurar archivos en tu servidor web**:
   - `.well-known/assetlinks.json` (Android)
   - `.well-known/apple-app-site-association` (iOS)

3. **Implementar la carga real de datos** en `PublicCatalogPage`:
   - Actualmente muestra un placeholder
   - Conectar con el API endpoint `api/catalogs-v2/public/{catalogId}`

4. **Agregar QR Code Generator** (opcional):
   - Instalar `qr_flutter: ^4.1.0`
   - Generar código QR del enlace para compartir

### 8. Flujo Completo

```
Usuario A (Vendedor)
    ↓
Crea catálogo público
    ↓
Presiona "Compartir"
    ↓
Copia: katalog://catalogo/abc123
    ↓
Envía por WhatsApp/Email
    ↓
Usuario B (Cliente)
    ↓
Hace clic en el enlace
    ↓
Se abre la app automáticamente
    ↓
Ve el catálogo sin login
```

### 9. Ventajas

✅ **Sin fricción**: Los clientes no necesitan crear cuenta
✅ **Compartir fácil**: Un solo enlace para todo el catálogo
✅ **Multiplataforma**: Funciona en Android e iOS
✅ **SEO friendly**: Con Universal Links, también indexable por Google
✅ **Tracking**: Puedes rastrear visitas por catálogo

### 10. Notas Importantes

- Los catálogos deben estar marcados como "públicos" para compartirse
- El ícono de compartir solo aparece en catálogos públicos
- Los enlaces personalizados (`katalog://`) son ideales para testing
- Los Universal Links (`https://`) requieren configuración en el servidor
