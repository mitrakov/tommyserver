package com.mitrakoff.self.tommylingo

class LingoService[F[_]](dao: LingoDao[F]):
  def getByKey(userId: Int, langCode: String, key: String): F[Option[(String, String, Option[String])]] = dao.fetch(userId, langCode, key)

  def getAll(userId: Int, langCode: String): F[List[(String, String, Option[String])]] = dao.fetch(userId, langCode)

  def upsert(dict: Dict): F[Int] = dao.persist(dict)

  def remove(dictKey: DictKey): F[Int] = dao.delete(dictKey)
