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
-- Table `atividade02`.`AG_TEMPO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_TEMPO` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ano` YEAR(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ano_mes_UNIQUE` (`ano` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`AG_ORGAO_SUPERIOR_ANO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_ORGAO_SUPERIOR_ANO` (
  `valor_orcado` FLOAT NULL,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `ORGAO_SUPERIOR_cod` INT NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `ORGAO_SUPERIOR_cod`),
  INDEX `fk_AG_TEMPO_ORGAO_SUPERIOR_ORGAO_SUPERIOR1_idx` (`ORGAO_SUPERIOR_cod` ASC) VISIBLE,
  CONSTRAINT `fk_AG_TEMPO_ORGAO_SUPERIOR_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`AG_TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AG_TEMPO_ORGAO_SUPERIOR_ORGAO_SUPERIOR1`
    FOREIGN KEY (`ORGAO_SUPERIOR_cod`)
    REFERENCES `atividade02`.`ORGAO_SUPERIOR` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`AG_FUNCAO_ANO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_FUNCAO_ANO` (
  `valor_orcado` FLOAT NULL,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `FUNCAO_cod` INT NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `FUNCAO_cod`),
  INDEX `fk_AG_FUNCAO_ANO_FUNCAO1_idx` (`FUNCAO_cod` ASC) VISIBLE,
  CONSTRAINT `fk_AG_FUNCAO_ANO_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`AG_TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AG_FUNCAO_ANO_FUNCAO1`
    FOREIGN KEY (`FUNCAO_cod`)
    REFERENCES `atividade02`.`FUNCAO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`AG_PROGRAMA_ANO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_PROGRAMA_ANO` (
  `valor_orcado` FLOAT NULL,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `PROGRAMA_cod` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `PROGRAMA_cod`),
  INDEX `fk_AG_PROGRAMA_ANO_PROGRAMA1_idx` (`PROGRAMA_cod` ASC) VISIBLE,
  CONSTRAINT `fk_AG_PROGRAMA_ANO_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`AG_TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AG_PROGRAMA_ANO_PROGRAMA1`
    FOREIGN KEY (`PROGRAMA_cod`)
    REFERENCES `atividade02`.`PROGRAMA` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`AG_ORGAO_SUBORDINADO_ANO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_ORGAO_SUBORDINADO_ANO` (
  `valor_orcado` FLOAT NULL,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `ORGAO_SUBORDINADO_cod` INT NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `ORGAO_SUBORDINADO_cod`),
  INDEX `fk_AG_ORGAO_SUBORDINADO_ANO_ORGAO_SUBORDINADO1_idx` (`ORGAO_SUBORDINADO_cod` ASC) VISIBLE,
  CONSTRAINT `fk_AG_ORGAO_SUBORDINADO_ANO_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`AG_TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AG_ORGAO_SUBORDINADO_ANO_ORGAO_SUBORDINADO1`
    FOREIGN KEY (`ORGAO_SUBORDINADO_cod`)
    REFERENCES `atividade02`.`ORGAO_SUBORDINADO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `atividade02`.`AG_ORGAO_SUBORDINADO_PROGRAMA_ANO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atividade02`.`AG_ORGAO_SUBORDINADO_PROGRAMA_ANO` (
  `valor_orcado` FLOAT NULL,
  `valor_liquidado` FLOAT NOT NULL,
  `TEMPO_id` INT NOT NULL,
  `ORGAO_SUBORDINADO_cod` INT NOT NULL,
  PRIMARY KEY (`TEMPO_id`, `ORGAO_SUBORDINADO_cod`),
  INDEX `fk_AG_ORGAO_SUBORDINADO_PROGRAMA_ANO_ORGAO_SUBORDINADO1_idx` (`ORGAO_SUBORDINADO_cod` ASC) VISIBLE,
  CONSTRAINT `fk_AG_ORGAO_SUBORDINADO_PROGRAMA_ANO_TEMPO1`
    FOREIGN KEY (`TEMPO_id`)
    REFERENCES `atividade02`.`AG_TEMPO` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AG_ORGAO_SUBORDINADO_PROGRAMA_ANO_ORGAO_SUBORDINADO1`
    FOREIGN KEY (`ORGAO_SUBORDINADO_cod`)
    REFERENCES `atividade02`.`ORGAO_SUBORDINADO` (`cod`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
