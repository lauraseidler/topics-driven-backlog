require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

User.create!([
                 {email: 'user1@htw-berlin.de', role: User.roles[:student]},
                 {email: 'user2@htw-berlin.de', role: User.roles[:student]},
                 {email: 'user3@htw-berlin.de', role: User.roles[:student]},
                 {email: 'user4@htw-berlin.de', role: User.roles[:instructor]},
                 {email: 'user5@htw-berlin.de', role: User.roles[:instructor]},
             ])

Course.create!([
                   {title: "B15.1 Informatik 3", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/info3", semester_type: "W", semester_year: 2017, short_title: "INFO3", allow_enrollment: true},
                   {title: "M1 Media Programming: Web Technology", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/media-programming-rails", semester_type: "W", semester_year: 2017, short_title: "M1 Rails", allow_enrollment: true},
                   {title: "B21.1 - B23.1 WTAT2: Agile Web Development", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2", semester_type: "W", semester_year: 2017, short_title: "WTAT2", allow_enrollment: true}
               ])
Topic.create!([
                  {title: "Rails and Active Record", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a1-activerecord/", course_id: 3},
                  {title: "Authentication & Testing", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a2-authentication/", course_id: 3},
                  {title: "Search, Database, Docker", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a3-search-database-docker/", course_id: 3},
                  {title: "Deployment & Javascript", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/a4-ci-cd-javascript/", course_id: 3},
                  {title: "Rails Security & External APIs", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/", course_id: 3},
                  {title: "Choose one yourself", url: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2/topics/", course_id: 3}
              ])
Sprint.create!([
                   {name: "Sprint 1", start_date: "2018-10-19", end_date: "2018-10-26", course_id: 3},
                   {name: "Sprint 2", start_date: "2018-11-02", end_date: "2018-11-16", course_id: 3},
                   {name: "Sprint 3", start_date: "2018-11-23", end_date: "2018-11-30", course_id: 3},
                   {name: "Sprint 4", start_date: "2018-12-07", end_date: "2018-12-14", course_id: 3},
                   {name: "Sprint 5", start_date: "2018-12-21", end_date: "2019-01-05", course_id: 3},
                   {name: "Sprint 6", start_date: "2019-01-11", end_date: "2019-01-18", course_id: 3}
               ])
Project.create!([
                    {title: "TABLE GAME PORTAL", course_id: 3, user_ids: [1]},
                    {title: "CourseR:​ ​ Course​ ​ Retrospective", course_id: 3, user_ids: [2]},
                ])

SprintPlanning.create!([
                            {project_id: 1, sprint_id: 1, planned: false},
                            {project_id: 1, sprint_id: 2, planned: false},
                            {project_id: 1, sprint_id: 3, planned: false},
                            {project_id: 1, sprint_id: 4, planned: false},
                            {project_id: 1, sprint_id: 5, planned: false},
                            {project_id: 1, sprint_id: 6, planned: false},
                            {project_id: 2, sprint_id: 1, planned: false},
                            {project_id: 3, sprint_id: 2, planned: false},
                            {project_id: 2, sprint_id: 3, planned: false},
                            {project_id: 2, sprint_id: 4, planned: false},
                            {project_id: 2, sprint_id: 5, planned: false},
                            {project_id: 2, sprint_id: 6, planned: false},
                        ])

# Project 1
Story.create!([
                  {title: "Auf​ der​​ Hauptseite​​ werden​  alle​ ​Spiele​ ​angezeigt. Neue​ ​Spiele​ ​hinzufügen​ / ​löschen​ ​und​ ​editieren",
                   description: nil, status: 2, points: nil, sprint_id: 1, project_id: 1, topic_id: 1},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ ein​ ​ Kommentar​ ​ zu​ ​ einem​ ​ Spiel schreiben/​ ​ löschen",
                   description: nil, status: 2, points: nil, sprint_id: 1, project_id: 1, topic_id: 1},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ ein​ ​ Spiel​ ​ anklicken​ ​ und​ ​ die Spieldetails​ ​ werden​ ​ mir​ ​ angezeigt.",
                   description: nil, status: 2, points: nil, sprint_id: 1, project_id: 1, topic_id: 1},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ die​ ​ Spiele​ ​ anhand​ ​ Tags sortieren.",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ mein​ ​ Profil​ ​ erstellen​ ​ und​ ​ Info über​ ​ mich​ ​ schreiben.",
                   description: nil, status: 2, points: nil, sprint_id: 2, project_id: 1, topic_id: 2},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ meine​ ​ Kontaktdaten​ ​ im​ ​ Profil speichern​ ​ und​ ​ angeben,​ ​ welche​ ​ Spiele​ ​ ich​ ​ besitze.",
                   description: nil, status: 2, points: nil, sprint_id: 2, project_id: 1, topic_id: 2},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ ein​ ​ Event​ ​ erstellen.",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ alle​ ​ Events​ ​ sehen",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ Daten​ ​ in​ ​ einem​ ​ Event​ ​ ändern​ ​ - Datum,​ ​ Treffpunkt​ ​ und​ ​ Info​ ​ ändern​ ​ oder​ ​ auch​ ​ ob​ ​ es um​ ​ Geld​ ​ gespielt​ ​ wird",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ entscheiden,​ ​ ob​ ​ das​ ​ Event öffentlich​ ​ ist​ ​ oder​ ​ nur​ ​ für​ ​ registrierte​ ​ User​ ​ zu​ ​ sehen ist.",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ andere​ ​ Teilnehmer​ ​ in​ ​ Event sehen.",
                   description: nil, status: 2, points: nil, sprint_id: 3, project_id: 1, topic_id: 3},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ ein​ ​ Spiel​ ​ bewerten.",
                   description: nil, status: 2, points: nil, sprint_id: 4, project_id: 1, topic_id: 4},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ alle​ ​ Spiele​ ​ finden​ ​ und​ ​ nach allen​ ​ Informationen​ ​ zum​ ​ Spiel​ ​ suchen.",
                   description: nil, status: 2, points: nil, sprint_id: 4, project_id: 1, topic_id: 4},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ ein​ ​ Kommentar​ ​ auf​ ​ das​ ​ Profil von​ ​ einem​ ​ Spieler​ ​ schreiben.",
                   description: nil, status: 2, points: nil, sprint_id: 4, project_id: 1, topic_id: 4},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ meine​ ​ Lieblingsspiele markieren.",
                   description: nil, status: 2, points: nil, sprint_id: 5, project_id: 1, topic_id: 5},
                  {title: "Der​ ​ Nutzer​ ​ kann​ ​ nach​ ​ Events,​ ​ Spielen​ ​ und​ ​ Spielern suchen​ ​ und​ ​ Filter​ ​ einsetzten",
                   description: nil, status: 2, points: nil, sprint_id: 5, project_id: 1, topic_id: 5},
                  {title: "Als​ ​ Nutzer​ ​ habe​ ​ ich​ ​ die​ ​ Möglichkeit,​ ​ andere​ ​ Spieler zu​ ​ kontaktieren​ ​ (Chat)",
                   description: nil, status: 2, points: nil, sprint_id: 5, project_id: 1, topic_id: 5},
                  {title: "Als​ ​ Nutzer​ ​ kann​ ​ ich​ ​ Eventslog​ ​ sehen.​ ​ (Wann​ ​ und was​ ​ gespielt​ ​ war)",
                   description: nil, status: 2, points: nil, sprint_id: 5, project_id: 1, topic_id: 5},
              ])

# Project 2
Story.create!([
                  {title: "Als​ ​ Student,​ ​ möchte​ ​ ich​ ​ über​ ​ eine Modulübersicht​ ​ genauere Informationen​ ​ über​ ​ eine Lehrveranstaltung​ ​ bei​ ​ einem​ ​ Dozenten angezeigt​ ​ bekommen.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 1},
                  {title: "Als​ ​ Student,​ ​ möchte​ ​ ich​ ​ Module​ ​ nach Studiengang​ ​ / ​ ​ Semester​ ​ gefiltert angezeigt​ ​ bekommen.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 2},
                  {title: "Als​ ​ Nutzer​ ​ möchte​ ​ ich​ ​ nach​ ​ einem bestimmten​ ​ Kurs​ ​ suchen​ ​ können.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 3},
                  {title: "Als​ ​ Dozent,​ ​ kann​ ​ ich​ ​ eine Beschreibung​ ​ zu​ ​ meinem​ ​ Kurs hochladen.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 3},
                  {title: "Als​ ​ nicht​ ​ autorisierter​ ​ Nutzer,​ ​ möchte ich​ ​ ein​ ​ Account​ ​ erstellen​ ​ können.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 2},
                  {title: "Als​ ​ autorisierter​ ​ Nutzer,​ ​ möchte​ ​ ich mich​ ​ anmelden​ ​ können.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 2},
                  {title: "Als​ ​ Nutzer,​ ​ möchte​ ​ ich​ ​ die​ ​ Möglichkeit haben​ ​ zu​ ​ sehen,​ ​ wie​ ​ andere​ ​ den​ ​ Kurs in​ ​ einem​ ​ Metriksystem​ ​ charakterisiert haben.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 4},
                  {title: "Als​ ​ autorisierter​ ​ Nutzer​ ​ (Student),​ ​ kann ich​ ​ meine​ ​ Erfahrungen​ ​ mit​ ​ dem​ ​ Kurs mit​ ​ anderen​ ​ teilen,​ ​ indem​ ​ ich Bewertungen​ ​ für​ ​ diesen​ ​ Kurs​ ​ im Metriksystem​ ​ eingebe.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 4},
                  {title: "Als​ ​ Nutzer​ ​ möchte​ ​ ich​ ​ alle​ ​ verfügbaren Kurse​ ​ sehen​ ​ können.",
                   description: nil, status: 0, points: nil, sprint_id: nil, project_id: 2, topic_id: 5},
              ])

# bypass validation errors by moving sprints back to time via database
Sprint.all.each do |sprint|
  start_date = sprint.start_date
  end_date = sprint.end_date
  sprint.update_columns(:start_date => start_date-1.years, :end_date => end_date-1.years)
end
