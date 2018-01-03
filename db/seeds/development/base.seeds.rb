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
                   {name: "Rails and Active Record", start_date: "2017-10-19", end_date: "2018-10-26", course_id: 3},
                   {name: "Authentication & Testing", start_date: "2018-11-02", end_date: "2018-11-16", course_id: 3},
                   {name: "Search Functionality, Database & Docker", start_date: "2018-11-23", end_date: "2018-11-30", course_id: 3},
                   {name: "Rails Security & Deployment", start_date: "2018-12-07", end_date: "2018-12-14", course_id: 3}
               ])
Project.create!([
                    {title: "WTAT2 Project 1", course_id: 3}
                ])
Story.create!([
                  {title: "As the Studiengangssprecher, I want to announce events relevant for IMI-Students.", description: nil, identifier: "S-1", status: 2, points: nil, sprint_id: 1, project_id: 1, topic_id: 1},
                  {title: "As an IMI-Student, I get an overview of events coming up within the next week.", description: nil, identifier: "S-2", status: 2, points: nil, sprint_id: 1, project_id: 1, topic_id: 1},
                  {title: "As an IMI-Student, I can see events that will be important for me, e.g. the Projektvergabe, or the Showtime, well ahead.", description: nil, identifier: "S-3", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "As the Studiengangssprecher, I can also keep an overview of the planning status (date set, room booked, announced etc) for each listed event.", description: nil, identifier: "S-4", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "As a Student, I can filter events that are relevant for me (B/M, Semester).", description: nil, identifier: "S-5", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "I can see the IMI-Calendar in my favourite Calendar Application.", description: nil, identifier: "S-6", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "S-1 and S-4 are only available when logged in as an Admin User.", description: nil, identifier: "S-7", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "As a SGS, I can edit the Categories of an event while editing the event.", description: nil, identifier: "S-8", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: nil},
                  {title: "Both as Student and SGS, I can log in with my FB4 Account (LDAP)", description: nil, identifier: "S-12", status: 0, points: nil, sprint_id: 2, project_id: 1, topic_id: nil},
                  {title: "As an SGS, I can edit the name of a category.", description: nil, identifier: "S-11", status: 0, points: nil, sprint_id: 2, project_id: 1, topic_id: nil},
                  {title: "As an SGS, I can combine two categories into one.", description: nil, identifier: "S-10", status: 0, points: nil, sprint_id: nil, project_id: 1, topic_id: 2},
                  {title: "As an SGS, I can delete Categories from an Category-Maintenance View listing all the Categories.", description: nil, identifier: "S-9", status: 0, points: nil, sprint_id: 2, project_id: 1, topic_id: 1}
              ])
SprintPosition.create!([
                           {position: 2, sprint_id: 1, story_id: 1},
                           {position: 1, sprint_id: 1, story_id: 2},
                           {position: 3, sprint_id: 2, story_id: 9},
                           {position: 4, sprint_id: 2, story_id: 12},
                           {position: 2, sprint_id: 2, story_id: 12},
                           {position: 1, sprint_id: 2, story_id: 11}
                       ])
ProjectPosition.create!([
                            {position: 1, project_id: 1, story_id: 9},
                            {position: 4, project_id: 1, story_id: 10},
                            {position: 3, project_id: 1, story_id: 11},
                            {position: 2, project_id: 1, story_id: 12},
                            {position: 12, project_id: 1, story_id: 1},
                            {position: 11, project_id: 1, story_id: 2},
                            {position: 10, project_id: 1, story_id: 3},
                            {position: 9, project_id: 1, story_id: 4},
                            {position: 8, project_id: 1, story_id: 5},
                            {position: 7, project_id: 1, story_id: 6},
                            {position: 6, project_id: 1, story_id: 7},
                            {position: 5, project_id: 1, story_id: 8}
                        ])
