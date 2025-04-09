package com.mitrakoff.self.tommylingo

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator

/*
https://www.oracle.com/java/technologies/javase/java8locales.html
CREATE TABLE lingo.dict (
 user_id INT NOT NULL,
 lang_code VARCHAR (8) NOT NULL,
 key VARCHAR (128) NOT NULL,
 translation VARCHAR (255) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (user_id, lang_code, key)
);

Conjugations: https://raw.githubusercontent.com/asosab/esp_verbos/master/esp_verbos.sql
*/

class LingoDao[F[_]](db: Db[F]):
  def fetch(userId: Int, langCode: String, key: String): F[Option[(String, String, Option[String])]] =
    db.run(sql"""SELECT key, translation, conjugaciones FROM lingo.dict LEFT OUTER JOIN lingo.esp_verbos ON key = verbo WHERE user_id = $userId AND lang_code = $langCode AND key = $key"""
      .query[(String, String, Option[String])].option)

  def fetch(userId: Int, langCode: String): F[List[(String, String, Option[String])]] =
    db.run(sql"""SELECT key, translation, conjugaciones FROM lingo.dict LEFT OUTER JOIN lingo.esp_verbos ON key = verbo WHERE user_id = $userId AND lang_code = $langCode"""
      .query[(String, String, Option[String])].to[List])

  @deprecated
  def fetchWithLimitAndRandom(userId: Int, langCode: String, limit: Int): F[List[(String, String)]] =
    db.run(sql"""SELECT key, translation FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode ORDER BY random() LIMIT $limit;""".query[(String, String)].to[List])

  @deprecated
  def fetchAllKeys(userId: Int, langCode: String): F[List[String]] =
    db.run(sql"""SELECT key FROM lingo.dict WHERE user_id = $userId AND lang_code = $langCode;""".query[String].to[List])

  def persist(dict: Dict): F[Int] =
    db.run(sql"""INSERT INTO lingo.dict (user_id, lang_code, key, translation)
           VALUES (${dict.dictKey.userId}, ${dict.dictKey.langCode}, ${dict.dictKey.key}, ${dict.translation})
           ON CONFLICT (user_id, lang_code, key) DO UPDATE SET translation = ${dict.translation}
           ;""".update.run)

  def delete(dictKey: DictKey): F[Int] = // TODO: make remove by PK!
    db.run(sql"""DELETE FROM lingo.dict WHERE user_id = ${dictKey.userId} AND lang_code = ${dictKey.langCode} AND key = ${dictKey.key};""".update.run)
