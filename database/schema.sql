-- database/schema.sql

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS consultpro_db;
USE consultpro_db;

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de clientes
CREATE TABLE IF NOT EXISTS clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(100),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de servicios
CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2),
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de proyectos
CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    client_id INT,
    status ENUM('pendiente', 'en_progreso', 'completado') DEFAULT 'pendiente',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- Tabla de mensajes de contacto
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    read_status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba

-- Usuarios (contraseña: password123)
INSERT INTO users (name, email, password, role) VALUES
('Admin User', 'admin@consultpro.com', 'pbkdf2:sha256:150000$TvEOYtlw$4becaa5d3e1b3457cc95f8cf7f5a54f41e324d10a5b95ef0b537a6145c1bb11f', 'admin'),
('Manager User', 'manager@consultpro.com', 'pbkdf2:sha256:150000$TvEOYtlw$4becaa5d3e1b3457cc95f8cf7f5a54f41e324d10a5b95ef0b537a6145c1bb11f', 'manager'),
('Regular User', 'user@consultpro.com', 'pbkdf2:sha256:150000$TvEOYtlw$4becaa5d3e1b3457cc95f8cf7f5a54f41e324d10a5b95ef0b537a6145c1bb11f', 'user');

-- Clientes
INSERT INTO clients (name, email, phone, company, address) VALUES
('Juan Pérez', 'juan@empresa1.com', '555-1234', 'Empresa ABC', 'Calle Principal 123, Ciudad'),
('María González', 'maria@empresa2.com', '555-5678', 'Corporación XYZ', 'Avenida Central 456, Ciudad'),
('Carlos Rodríguez', 'carlos@empresa3.com', '555-9012', 'Industrias DEF', 'Boulevard Norte 789, Ciudad'),
('Ana Martínez', 'ana@empresa4.com', '555-3456', 'Compañía GHI', 'Calle Sur 321, Ciudad'),
('Roberto López', 'roberto@empresa5.com', '555-7890', 'Grupo JKL', 'Avenida Este 654, Ciudad');

-- Servicios
INSERT INTO services (name, description, price, image) VALUES
('Consultoría Estratégica', 'Asesoramiento integral para definir la dirección estratégica de su empresa y lograr sus objetivos de negocio.', 1500.00, 'estrategia.jpg'),
('Transformación Digital', 'Implementación de tecnologías y procesos para digitalizar y optimizar su negocio.', 2500.00, 'digital.jpg'),
('Gestión de Proyectos', 'Planificación, ejecución y control de proyectos para garantizar resultados exitosos.', 1200.00, 'proyectos.jpg'),
('Marketing y Ventas', 'Estrategias efectivas para aumentar su presencia en el mercado y mejorar sus ventas.', 1800.00, 'marketing.jpg'),
('Optimización de Procesos', 'Análisis y mejora de los procesos operativos para aumentar la eficiencia y reducir costos.', 1700.00, 'procesos.jpg');

-- Proyectos
INSERT INTO projects (name, description, client_id, status, start_date, end_date) VALUES
('Implementación ERP', 'Implementación completa de sistema ERP para optimizar procesos internos', 1, 'completado', '2024-01-15', '2024-03-20'),
('Campaña Marketing Digital', 'Diseño y ejecución de campaña integral en plataformas digitales', 2, 'en_progreso', '2024-03-01', '2024-06-30'),
('Reestructuración Departamental', 'Análisis y reorganización de la estructura organizativa', 3, 'pendiente', '2024-05-01', '2024-08-15'),
('Desarrollo Web Corporativo', 'Creación de sitio web corporativo con funcionalidades avanzadas', 4, 'en_progreso', '2024-02-10', '2024-04-30'),
('Plan Estratégico 2025', 'Definición del plan estratégico para el próximo año', 5, 'pendiente', '2024-06-15', '2024-09-01');

-- Mensajes de contacto
INSERT INTO contact_messages (name, email, message, read_status) VALUES
('Pedro Sánchez', 'pedro@ejemplo.com', 'Me gustaría recibir más información sobre sus servicios de consultoría estratégica.', FALSE),
('Laura Gómez', 'laura@ejemplo.com', 'Estamos interesados en contratar sus servicios para un proyecto de transformación digital.', TRUE),
('Miguel Torres', 'miguel@ejemplo.com', 'Quisiera agendar una reunión para discutir posibilidades de colaboración.', FALSE);
