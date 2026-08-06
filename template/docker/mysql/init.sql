-- Script de Inicialización de Base de Datos MySQL
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

-- 1. Tabla Roles
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Tabla Usuarios
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NULL,
    role_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at DATETIME NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
);

-- Datos Iniciales (Seed Data)
INSERT IGNORE INTO roles (id, name, description) VALUES 
(1, 'Admin', 'Administrador del sistema'),
(2, 'Client', 'Cliente del sistema');

-- Stored Procedures
DELIMITER //
CREATE PROCEDURE sp_users_register(
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_phone VARCHAR(100),
    IN p_role_id INT
)
BEGIN
    INSERT INTO users (full_name, email, password_hash, phone, role_id)
    VALUES (p_full_name, p_email, p_password_hash, p_phone, p_role_id);
     
    SELECT id AS Id,
        full_name AS FullName,
        email AS Email,
        password_hash AS PasswordHash,
        phone AS Phone,
        role_id AS RoleId,
        is_active AS IsActive,
        is_deleted AS IsDeleted,
        deleted_at AS DeletedAt,
        created_at AS CreatedAt,
        updated_at AS UpdatedAt
    FROM users WHERE id = LAST_INSERT_ID();
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_users_get_by_email(
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT 
        u.id AS Id,
        u.full_name AS FullName,
        u.email AS Email,
        u.password_hash AS PasswordHash,
        u.phone AS Phone,
        u.role_id AS RoleId,
        r.name AS Role,
        u.is_active AS IsActive,
        u.is_deleted AS IsDeleted,
        u.deleted_at AS DeletedAt,
        u.created_at AS CreatedAt,
        u.updated_at AS UpdatedAt
    FROM users u
    INNER JOIN roles r ON u.role_id = r.id
    WHERE u.email = p_email AND u.is_deleted = FALSE;
END //
DELIMITER ;
