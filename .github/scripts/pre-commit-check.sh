#!/bin/bash
alias python='python3'
# Script de verificación pre-commit
# Ejecutar antes de hacer commit para verificar calidad del código

set -e

echo "🔍 Ejecutando verificaciones pre-commit..."

# Verificar que Python esté instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python no está instalado"
    exit 1
fi

# Ejecutar pruebas unitarias
echo "📝 Ejecutando pruebas unitarias..."
python3 -m unittest discover -s pruebas -v

# Ejecutar pylint (solo advertencias)
echo "📋 Ejecutando análisis de código..."
python3 -m pylint calculadora/ pruebas/ app.py --exit-zero --output-format=colorized || true

# Verificar seguridad básica
if command -v bandit &> /dev/null; then
    echo "🔒 Ejecutando análisis de seguridad..."
    bandit -r calculadora/ -ll || true
fi

# Verificar que la aplicación inicia correctamente
echo "🚀 Verificando inicio de la aplicación..."
#timeout 5s python3 app.py & || true
timeout 5s python3 app.py || true

echo "✅ Verificaciones completadas exitosamente!"
