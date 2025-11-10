# Catálogo TalentPitch

Una aplicación Flutter modular para el catálogo de productos TalentPitch.

## 🚀 Características

- ✅ Arquitectura modular con paquetes separados
- ✅ Soporte multi-flavor (development, production, qa)
- ✅ Internacionalización (i18n)
- ✅ Gestión de estado con BLoc
- ✅ Navegación con GoRouter
- ✅ Base de datos local con Hive
- ✅ Integración de pagos con Wompi
- ✅ UI responsiva para mobile y desktop

## 📁 Estructura del Proyecto

```
lib/
├── app/                    # Configuración principal de la app
├── core/                   # Funcionalidades básicas y utilidades
├── feature/                # Características/módulos de la app
│   ├── auth/              # Autenticación
│   ├── cart/              # Carrito de compras
│   ├── home/              # Página principal
│   ├── product/           # Productos
│   └── ...
├── injection/             # Inyección de dependencias
└── l10n/                  # Archivos de localización

packages/
├── api_helper/            # Cliente HTTP y helpers de API
├── api_repository/        # Repositorios de datos
└── talentpitch_ui/        # Componentes UI reutilizables
```

## 🛠️ Configuración del Entorno

### Prerrequisitos

- Flutter SDK ≥ 3.6.1
- Dart SDK ≥ 3.6.1
- Android Studio / VS Code
- Git

### Instalación

1. **Instalar dependencias**
   ```bash
   # Dependencias principales
   flutter clean && flutter pub get
   
   # Dependencias de los paquetes
   cd packages/talentpitch_ui && flutter pub get && cd ../..
   cd packages/api_helper && flutter pub get && cd ../..
   cd packages/api_repository && flutter pub get && cd ../..
   ```

2. **Generar archivos de localización**
   ```bash
   flutter gen-l10n
   ```

## 🚀 Ejecución

### Desarrollo (Recomendado)
```bash
flutter run --flavor development -t lib/main_development.dart
```

### Producción
```bash
flutter run --flavor production -t lib/main_production.dart
```

### QA
```bash
flutter run --flavor qa -t lib/main_qa.dart
```

## 🏗️ Build

### Android
```bash
# Development
flutter build apk --flavor development -t lib/main_development.dart

# Production  
flutter build apk --flavor production -t lib/main_production.dart
```

### iOS
```bash
# Development
flutter build ios --flavor development -t lib/main_development.dart

# Production
flutter build ios --flavor production -t lib/main_production.dart
```

**Nota:** Los flavors para iOS necesitan configuración adicional en Xcode.

## 🔧 Comandos Útiles

### Limpiar y reorganizar proyecto
```bash
flutter clean
flutter pub get
cd packages/talentpitch_ui && flutter pub get && cd ../..
cd packages/api_helper && flutter pub get && cd ../..  
cd packages/api_repository && flutter pub get && cd ../..
```

### Verificar código
```bash
flutter analyze
```

### Generar código
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📦 Arquitectura

El proyecto utiliza una **arquitectura monorepo** con paquetes separados:

- **packages/talentpitch_ui**: Componentes UI reutilizables
- **packages/api_helper**: Cliente HTTP y manejo de APIs  
- **packages/api_repository**: Repositorios y lógica de datos

## 🐛 Solución de Problemas

Si encuentras errores:

1. **Errores de dependencias**: 
   ```bash
   flutter clean && flutter pub get
   ```

2. **Errores de build**: 
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Errores de iOS**: Configura los flavors en Xcode

## 🤝 Contribución

El proyecto está basado en varios patrones de diseño y metodología monorepo. Revisa la carpeta `packages/` para entender la estructura modular.

## 📞 Soporte

Para soporte y preguntas, contacta al equipo de desarrollo de TalentPitch.