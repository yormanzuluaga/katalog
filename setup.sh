#!/bin/bash

# Script para reorganizar y configurar el proyecto TalentPitch

echo "🚀 Configurando proyecto TalentPitch..."

# Función para imprimir en colores
print_success() {
    echo "✅ $1"
}

print_error() {
    echo "❌ $1"
}

print_info() {
    echo "ℹ️  $1"
}

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    print_error "Flutter no está instalado. Por favor, instala Flutter primero."
    exit 1
fi

print_info "Verificando versión de Flutter..."
flutter --version

# Limpiar proyecto
print_info "Limpiando proyecto..."
flutter clean

# Instalar dependencias principales
print_info "Instalando dependencias principales..."
if flutter pub get; then
    print_success "Dependencias principales instaladas"
else
    print_error "Error instalando dependencias principales"
    exit 1
fi

# Instalar dependencias de paquetes
print_info "Instalando dependencias de talentpitch_ui..."
cd packages/talentpitch_ui
if flutter pub get; then
    print_success "Dependencias de talentpitch_ui instaladas"
else
    print_error "Error instalando dependencias de talentpitch_ui"
    cd ../..
    exit 1
fi
cd ../..

print_info "Instalando dependencias de api_helper..."
cd packages/api_helper
if flutter pub get; then
    print_success "Dependencias de api_helper instaladas"
else
    print_error "Error instalando dependencias de api_helper"
    cd ../..
    exit 1
fi
cd ../..

print_info "Instalando dependencias de api_repository..."
cd packages/api_repository
if flutter pub get; then
    print_success "Dependencias de api_repository instaladas"
else
    print_error "Error instalando dependencias de api_repository"
    cd ../..
    exit 1
fi
cd ../..

# Generar localizaciones
print_info "Generando archivos de localización..."
if flutter gen-l10n; then
    print_success "Archivos de localización generados"
else
    print_error "Error generando archivos de localización"
fi

# Verificar proyecto
print_info "Verificando código..."
flutter analyze --no-fatal-infos

print_success "🎉 Proyecto configurado correctamente!"
print_info "Comandos útiles:"
echo "  flutter run --flavor development -t lib/main_development.dart"
echo "  flutter run --flavor production -t lib/main_production.dart"
echo "  flutter run --flavor qa -t lib/main_qa.dart"
echo ""
print_info "Para más información, consulta el README.md"
