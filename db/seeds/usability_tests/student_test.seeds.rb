require 'database_cleaner'

DatabaseCleaner.clean_with(:truncation)

Course.create!([
                   {title: "B15.1 Informatik 3", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/info3", semester_type: "W", semester_year: 2017, short_title: "INFO3"},
                   {title: "M1 Media Programming: Web Technology", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/media-programming-rails", semester_type: "W", semester_year: 2017, short_title: "M1 Rails"},
                   {title: "B21.1 - B23.1 WTAT2: Agile Web Development", hyperlink: "http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2", semester_type: "W", semester_year: 2017, short_title: "WTAT2"}
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
                   {name: "Sprint 1", start_date: "2017-10-19", end_date: "2017-10-26", course_id: 3},
                   {name: "Sprint 2", start_date: "2017-11-02", end_date: "2017-11-16", course_id: 3},
                   {name: "Sprint 3", start_date: "2017-11-23", end_date: "2017-11-30", course_id: 3},
                   {name: "Sprint 4", start_date: "2017-12-07", end_date: "2017-12-14", course_id: 3},
                   {name: "Sprint 5", start_date: "2017-12-21", end_date: "2018-01-05", course_id: 3},
                   {name: "Sprint 6", start_date: "2018-01-11", end_date: "2018-01-18", course_id: 3}
               ])