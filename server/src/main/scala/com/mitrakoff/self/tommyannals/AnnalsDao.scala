package com.mitrakoff.self.tommyannals

import com.mitrakoff.self.Db
import com.mitrakoff.self.auth.Id
import doobie.implicits.toSqlInterpolator
import io.circe.Json

import java.time.LocalDate

// notes: you must specify schema name (`annals.`) explicitly!

/*
CREATE TABLE annals."user" (
	user_id serial4 NOT NULL,
	login varchar(128) NOT NULL,
	hash varchar(255) NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT user_login_key UNIQUE (login),
	CONSTRAINT user_pkey PRIMARY KEY (user_id)
);
CREATE TABLE annals."event" (
	event_id serial4 NOT NULL,
	user_id int4 NOT NULL,
	"name" varchar(128) NOT NULL,
	description varchar(255) NULL,
  rank int2 NOT NULL DEFAULT 100,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	deprecated_at timestamp NULL,
	CONSTRAINT event_pkey PRIMARY KEY (event_id),
	CONSTRAINT event_user_name UNIQUE (user_id, name),
	CONSTRAINT event_user_id_fkey FOREIGN KEY (user_id) REFERENCES annals."user"(user_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE annals.param (
	param_id serial4 NOT NULL,
	event_id int4 NOT NULL,
	"name" varchar(128) NOT NULL,
	description varchar(255) NULL,
	"type" annals."paramtype" DEFAULT 'S'::annals.paramtype NOT NULL,
	unit varchar(64) NULL,
	default_value varchar(255) NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT param_event_name UNIQUE (event_id, name),
	CONSTRAINT param_pkey PRIMARY KEY (param_id),
	CONSTRAINT param_event_id_fkey FOREIGN KEY (event_id) REFERENCES annals."event"(event_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE annals.chronicle (
	id bigserial NOT NULL,
	"date" date DEFAULT now() NOT NULL,
	event_id int4 NOT NULL,
	params jsonb NOT NULL,
	"comment" varchar(255) NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT chronicle_pkey PRIMARY KEY (id),
	CONSTRAINT chronicle_event_id_fkey FOREIGN KEY (event_id) REFERENCES annals."event"(event_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
*/
class AnnalsDao[F[_]](db: Db[F]):
  case class EventParam(eventName: String, eventDescription: Option[String], name: String, description: Option[String], `type`: String, unit: Option[String], defaultValue: Option[String])

  def fetchAllForDate(userId: Id, date: LocalDate): F[List[Chronicle]] =
    import doobie.implicits.javatimedrivernative.JavaLocalDateMeta
    import doobie.implicits.autoDerivedRead
    import doobie.postgres.circe.jsonb.implicits.jsonbGet // this is needed for JSONB!
    db.run(sql"""SELECT id, date, event.name, params, comment
                 FROM annals.chronicle
                 INNER JOIN annals.event USING(event_id)
                 WHERE date = $date AND user_id = $userId ORDER BY rank;""".query[Chronicle].to[List]
    )

  def fetchSchema(userId: Id): F[List[EventParam]] =
    import doobie.implicits.autoDerivedRead
    db.run(sql"""SELECT event.name, event.description, param.name, param.description, param.type, param.unit, param.default_value
                 FROM annals.event
                 INNER JOIN annals.param USING(event_id)
                 WHERE user_id = $userId AND deprecated_at IS NULL;""".query[EventParam].to[List]
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

  def deleteById(chronicleId: Id): F[Int] =
    db.run(sql"""DELETE FROM annals.chronicle WHERE id = $chronicleId""".update.run)
