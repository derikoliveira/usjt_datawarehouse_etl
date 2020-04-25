-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema atividade02
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema atividade02
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `atividade02` DEFAULT CHARACTER SET utf8 ;
USE `atividade02` ;

-- -----------------------------------------------------
-- Table `atividade02`.`TEMPO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`TEMPO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ano_mes` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ano_mes_UNIQUE` (`ano_mes` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `atividade02`.`PROGRAMA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`PROGRAMA` (
  `cod` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`cod`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`ACAO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`ACAO` (
  `cod` VARCHAR(20) NOT NULL,
  `PROGRAMA_cod` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`cod`),
  INDEX `fk_ACAO_PROGRAMA1_idx` (`PROGRAMA_cod` ASC) VISIBLE,
  CONSTRAINT `fk_ACAO_PROGRAMA1`
    FOREIGN KEY (`PROGRAMA_cod`)
    REFERENCES `atividade02`.`PROGRAMA` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`FUNCAO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`FUNCAO` (
  `cod` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`cod`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`SUBFUNCAO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`SUBFUNCAO` (
  `cod` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `FUNCAO_cod` INT NOT NULL,
  PRIMARY KEY (`cod`),
  INDEX `fk_SUBFUNCAO_FUNCAO1_idx` (`FUNCAO_cod` ASC) VISIBLE,
  CONSTRAINT `fk_SUBFUNCAO_FUNCAO1`
    FOREIGN KEY (`FUNCAO_cod`)
    REFERENCES `atividade02`.`FUNCAO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`ORGAO_SUPERIOR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`ORGAO_SUPERIOR` (
  `cod` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`cod`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`ORGAO_SUBORDINADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`ORGAO_SUBORDINADO` (
  `cod` INT NOT NULL,
  `ORGAO_SUPERIOR_cod` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`cod`),
  INDEX `fk_ORGAO_SUBORDINADO_ORGAO_SUPERIOR1_idx` (`ORGAO_SUPERIOR_cod` ASC) VISIBLE,
  CONSTRAINT `fk_ORGAO_SUBORDINADO_ORGAO_SUPERIOR1`
    FOREIGN KEY (`ORGAO_SUPERIOR_cod`)
    REFERENCES `atividade02`.`ORGAO_SUPERIOR` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`UNIDADE_ORCAMENTARIA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`UNIDADE_ORCAMENTARIA` (
  `cod` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `ORGAO_SUBORDINADO_cod` INT NOT NULL,
  PRIMARY KEY (`cod`),
  INDEX `fk_UNIDADE_ORCAMENTARIA_ORGAO_SUBORDINADO1_idx` (`ORGAO_SUBORDINADO_cod` ASC) VISIBLE,
  CONSTRAINT `fk_UNIDADE_ORCAMENTARIA_ORGAO_SUBORDINADO1`
    FOREIGN KEY (`ORGAO_SUBORDINADO_cod`)
    REFERENCES `atividade02`.`ORGAO_SUBORDINADO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`FATO_ORCAMENTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`FATO_ORCAMENTO` (
  `valor_orcado` FLOAT,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `ACAO_cod` VARCHAR(20) NOT NULL,
  `SUBFUNCAO_cod` INT NOT NULL,
  `UNIDADE_ORCAMENTARIA_cod` INT NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `ACAO_cod`, `SUBFUNCAO_cod`, `UNIDADE_ORCAMENTARIA_cod`),
  INDEX `fk_FATO_ORCAMENTO_ACAO1_idx` (`ACAO_cod` ASC) VISIBLE,
  INDEX `fk_FATO_ORCAMENTO_SUBFUNCAO1_idx` (`SUBFUNCAO_cod` ASC) VISIBLE,
  INDEX `fk_FATO_ORCAMENTO_UNIDADE_ORCAMENTARIA1_idx` (`UNIDADE_ORCAMENTARIA_cod` ASC) VISIBLE,
  CONSTRAINT `fk_FATO_ORCAMENTO_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FATO_ORCAMENTO_ACAO1`
    FOREIGN KEY (`ACAO_cod`)
    REFERENCES `atividade02`.`ACAO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FATO_ORCAMENTO_SUBFUNCAO1`
    FOREIGN KEY (`SUBFUNCAO_cod`)
    REFERENCES `atividade02`.`SUBFUNCAO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FATO_ORCAMENTO_UNIDADE_ORCAMENTARIA1`
    FOREIGN KEY (`UNIDADE_ORCAMENTARIA_cod`)
    REFERENCES `atividade02`.`UNIDADE_ORCAMENTARIA` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
