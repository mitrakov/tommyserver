package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator
import io.circe.Json
import java.time.LocalDate

// notes: you must specify schema name (`annals.`) explicitly!
class AnnalsDao[F[_]](db: Db[F]):
  case class Chronicle(date: LocalDate, eventName: String, params: Json, comment: Option[String])
  case class EventParam(eventName: String, eventDescription: Option[String], name: String, description: Option[String], `type`: String, unit: Option[String], defaultValue: Option[String])

  def fetchAllForDate(userId: Id, date: LocalDate): F[List[Chronicle]] =
    import doobie.implicits.javatimedrivernative.JavaLocalDateMeta
    import doobie.implicits.derived
    import doobie.postgres.circe.jsonb.implicits.jsonbGet // this is needed for JSONB!
    db.run(sql"""SELECT date, event.name, params, comment
                 FROM annals.chronicle
                 INNER JOIN annals.event USING(event_id)
                 WHERE date = $date AND user_id = $userId;""".query[Chronicle].to[List]
    )

  def fetchSchema(userId: Id): F[List[EventParam]] =
    import doobie.implicits.derived
    db.run(sql"""SELECT event.name, event.description, param.name, param.description, param.type, param.unit, param.default_value
                 FROM annals.event
                 INNER JOIN annals.param USING(event_id)
                 WHERE user_id = $userId;""".query[EventParam].to[List]
    )

  def insert(date: LocalDate, eventId: Id, params: Json, comment: Option[String]): F[Int] =
    import doobie.implicits.javatimedrivernative.JavaLocalDateMeta
    import doobie.postgres.circe.jsonb.implicits.jsonbPut
    db.run(sql"""INSERT INTO annals.chronicle (date, event_id, params, comment)
                 VALUES ($date, $eventId, $params, $comment);""".update.run
    )

  def findEventId(userId: Id, eventName: String): F[Option[Id]] =
    db.run(
      sql"""SELECT event_id FROM annals.event WHERE user_id = $userId AND name = $eventName;""".query[Id].option
    )
