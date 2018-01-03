# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ProjectPosition.destroy_all
SprintPosition.destroy_all
Story.destroy_all
Sprint.destroy_all
Project.destroy_all
Course.destroy_all


info3 = Course.create(
    title: 'B15.1 Informatik 3',
    short_title: 'INFO3',
    hyperlink: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/info3',
    semester_type: 'W',
    semester_year: '2017'
)
m1 = Course.create(
    title: 'M1 Media Programming: Web Technology',
    short_title: 'M1 Rails',
    hyperlink: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/media-programming-rails',
    semester_type: 'W',
    semester_year: '2017'
)
wtat2 = Course.create(
    title: 'B21.1 - B23.1 WTAT2: Agile Web Development',
    short_title: 'WTAT2',
    hyperlink: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2',
    semester_type: 'W',
    semester_year: '2017'
)

project1 = Project.create(
    title: 'WTAT2 Project 1',
    course_id: wtat2.id
)

t1 = Sprint.create(
    name: 'Rails and Active Record',
    start_date: Date.new(2018, 10, 19),
    end_date: Date.new(2018, 10, 26),
    course_id: wtat2.id
)
t2 = Sprint.create(
    name: 'Authentication & Testing',
    start_date: Date.new(2018, 11, 02),
    end_date: Date.new(2018, 11, 16),
    course_id: wtat2.id,
)
t3 = Sprint.create(
    name: 'Search Functionality, Database & Docker',
    start_date: Date.new(2018, 11, 23),
    end_date: Date.new(2018, 11, 30),
    course_id: wtat2.id
)
t4 = Sprint.create(
    name: 'Rails Security & Deployment',
    start_date: Date.new(2018, 12, 07),
    end_date: Date.new(2018, 12, 14),
    course_id: wtat2.id
)

s1 = Story.new(
    title: 'As the Studiengangssprecher, I want to announce events relevant for IMI-Students.',
    status: Story.statuses[:closed],
    identifier: 'S-1',
    sprint_id: t1.id,
    project_id: project1.id
).save(validate: false)
s2 = Story.new(
    title: 'As an IMI-Student, I get an overview of events coming up within the next week.',
    identifier: 'S-2',
    status: Story.statuses[:closed],
    sprint_id: t1.id,
    project_id: project1.id
).save(validate: false)
s3 = Story.new(
    title: 'As an IMI-Student, I can see events that will be important for me, e.g. the Projektvergabe, or the Showtime, well ahead.',
    identifier: 'S-3',
    project_id: project1.id
).save(validate: false)
s4 = Story.new(
    title: 'As the Studiengangssprecher, I can also keep an overview of the planning status (date set, room booked, announced etc) for each listed event.',
    identifier: 'S-4',
    project_id: project1.id
).save(validate: false)
s5 = Story.new(
    title: 'As a Student, I can filter events that are relevant for me (B/M, Semester).',
    identifier: 'S-5',
    project_id: project1.id
).save(validate: false)
s6 = Story.new(
    title: 'I can see the IMI-Calendar in my favourite Calendar Application.',
    identifier: 'S-6',
    project_id: project1.id
).save(validate: false)
s7 = Story.new(
    title: 'S-1 and S-4 are only available when logged in as an Admin User.',
    identifier: 'S-7',
    project_id: project1.id
).save(validate: false)
s8 = Story.new(
    title: 'As a SGS, I can edit the Categories of an event while editing the event.',
    identifier: 'S-8',
    project_id: project1.id
).save(validate: false)
s9 = Story.new(
    title: 'As an SGS, I can delete Categories from an Category-Maintenance View listing all the Categories.',
    identifier: 'S-9',
    project_id: project1.id
).save(validate: false)
s10 = Story.new(
    title: 'As an SGS, I can combine two categories into one.',
    identifier: 'S-10',
    project_id: project1.id
).save(validate: false)
s11 = Story.new(
    title: 'As an SGS, I can edit the name of a category.',
    identifier: 'S-11',
    project_id: project1.id
).save(validate: false)
s12 = Story.new(
    title: 'Both as Student and SGS, I can log in with my FB4 Account (LDAP)',
    identifier: 'S-12',
    project_id: project1.id
).save(validate: false)
