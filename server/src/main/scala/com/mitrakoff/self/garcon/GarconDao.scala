package com.mitrakoff.self.garcon

import com.mitrakoff.self.{Db, Id}
import doobie.implicits.toSqlInterpolator

/*
CREATE SCHEMA IF NOT EXISTS garcon;
CREATE TABLE IF NOT EXISTS garcon."user" (
    user_id SERIAL NOT NULL PRIMARY KEY,
    login VARCHAR(128) NOT NULL UNIQUE,
    hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS garcon.word (
    word_id SERIAL NOT NULL PRIMARY KEY,
    word VARCHAR(64) NOT NULL UNIQUE,
    translations VARCHAR(128) NOT NULL,
    frequency INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX word_frequency_idx ON garcon.word USING btree (frequency);
CREATE TABLE IF NOT EXISTS garcon.progress (
    progress_id BIGSERIAL NOT NULL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES garcon.user (user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    word_id INT NOT NULL REFERENCES garcon.word (word_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    correct SMALLINT NOT NULL DEFAULT 0,
    wrong   SMALLINT NOT NULL DEFAULT 0,
    "skip" BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, word_id)
);
*/
class GarconDao[F[_]](db: Db[F]):
  case class Word(word: String, translations: String)

  def fetchNext(userId: Id, page: Int, limit: Int = 20): F[List[Word]] =
    import doobie.implicits.derived
    val offset = page * limit
    val sql = sql"""SELECT word, translations FROM garcon.word ORDER BY frequency DESC OFFSET $offset LIMIT $limit;"""
    db.run(sql.query[Word].to[List])
