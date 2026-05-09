# 🏦 BTG Challenge

Aplicación de gestión de fondos de inversión desarrollada en **Flutter**, siguiendo principios de **Clean Architecture** y el patrón de estado **BLoC**. Permite a los usuarios consultar fondos disponibles (FPV/FIC), suscribirse, cancelar y visualizar el historial de transacciones.

---

## 📺 Demo

| Plataforma | Enlace |
|------------|--------|
| 🎥 Video (YouTube) | [Ver demo en YouTube](https://youtu.be/ztDdtd-tiSA) |
| 🌐 Web (Live) | [Ver demo en vivo](https://abeltarazona.com/demo/btg-challenge) |

---

## 🏗️ Arquitectura del Proyecto

El proyecto sigue **Clean Architecture** organizado en las siguientes capas:

```
lib/
├── core/                  # Configuración transversal
│   ├── router/            # Navegación (GoRouter)
│   ├── theme/             # Tema y diseño visual
│   └── utils/             # Utilidades y responsive design
├── data/                  # Capa de datos
│   ├── datasources/       # Fuentes de datos (mock JSON)
│   ├── models/            # Modelos de datos (DTOs)
│   └── repositories/      # Implementación de repositorios
├── domain/                # Capa de dominio
│   ├── entities/          # Entidades de negocio
│   └── repositories/      # Contratos (interfaces)
├── presentation/          # Capa de presentación
│   ├── dashboard/         # Pantalla principal (Home)
│   ├── funds/             # Detalle y suscripción de fondos
│   ├── shell/             # Layout principal (AppShell)
│   └── transactions/      # Historial de transacciones
└── main.dart              # Punto de entrada
```

---

## ⚙️ Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalados:

| Herramienta | Versión mínima | Verificar instalación |
|-------------|----------------|----------------------|
| **Flutter SDK** | `3.11.x` o superior | `flutter --version` |
| **Dart SDK** | `3.11.4` o superior | `dart --version` |
| **Git** | Cualquier versión reciente | `git --version` |

> [!NOTE]
> El proyecto utiliza datos **mock** (JSON locales en `assets/mocks/`), por lo que **no requiere** configuración de backend ni base de datos.

---

## 🚀 Instrucciones de Ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/AbelTaraworka/btg-challenge.git
cd btg-challenge
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Verificar entorno

```bash
flutter doctor
```

Asegúrate de que no haya errores críticos en la salida.

### 4. Ejecutar la aplicación

#### 📱 Android / iOS (Emulador o dispositivo físico)

```bash
flutter run
```

#### 🌐 Web (Chrome)

```bash
flutter run -d chrome
```

#### 🖥️ Windows

```bash
flutter run -d windows
```

---

## 🧪 Ejecutar Tests

El proyecto incluye **tests unitarios** para los BLoC y estados:

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar un test específico
flutter test test/bloc/home_bloc_test.dart
flutter test test/bloc/funds_bloc_test.dart
flutter test test/bloc/transactions_bloc_test.dart
```

### Tests disponibles

| Archivo | Descripción |
|---------|-------------|
| `home_bloc_test.dart` | Tests del BLoC de la pantalla principal |
| `home_state_test.dart` | Tests de los estados del Home |
| `funds_bloc_test.dart` | Tests del BLoC de fondos (suscripción/cancelación) |
| `funds_state_test.dart` | Tests de los estados de fondos |
| `transactions_bloc_test.dart` | Tests del BLoC de transacciones |
| `transactions_state_test.dart` | Tests de los estados de transacciones |

---

## 📦 Dependencias Principales

| Paquete | Uso |
|---------|-----|
| `flutter_bloc` | Gestión de estado con patrón BLoC |
| `go_router` | Navegación declarativa |
| `google_fonts` | Tipografías personalizadas |
| `font_awesome_flutter` | Iconografía |
| `bloc_test` | Testing de BLoCs |
| `mocktail` | Mocking para tests |

---

## 📄 Licencia

Este proyecto fue desarrollado como parte del **BTG Pactual Challenge**.
