package com.mitrakoff.self.tommylingo

class LingoService[F[_]](dao: LingoDao[F]):
  def getAll(userId: Int, langCode: String): F[List[(String, String)]] = dao.fetch(userId, langCode)

  def upsert(dict: Dict): F[Int] = dao.persist(dict)

  def remove(dictKey: DictKey): F[Int] = dao.delete(dictKey)
