# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Story.destroy_all
Sprint.destroy_all
Course.destroy_all


info3 = Course.create(
          title: 'Informatics 3',
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
    title: 'WTAT 2 - Agile Web Development',
    short_title: 'WTAT2',
    hyperlink: 'http://home.htw-berlin.de/~kleinen/classes/ws2017/wtat2',
    semester_type: 'W',
    semester_year: '2017'
)


t1 = Sprint.create(
    name: 'Rails and Active Record',
    start_date: Date.new(2017,10,19),
    end_date: Date.new(2017,10,26),
    course_id: wtat2.id
)
t2 = Sprint.create(
    name: 'Authentication & Testing',
    start_date: Date.new(2017,11,02),
    end_date: Date.new(2017,11,16),
    course_id: wtat2.id
)
t3 = Sprint.create(
    name: 'Search Functionality, Database & Docker',
    start_date: Date.new(2017,11,23),
    end_date: Date.new(2017,11,30),
    course_id: wtat2.id
)
t4 = Sprint.create(
    name: 'Rails Security & Deployment',
    start_date: Date.new(2017,12,07),
    end_date: Date.new(2017,12,14),
    course_id: wtat2.id
)

s1 = Story.new(
  title: 'As the Studiengangssprecher, I want to announce events relevant for IMI-Students.',
  status: Story.statuses[:closed],
  identifier: 'S-1'
).save(validate: false)
s2 = Story.new(
    title: 'As an IMI-Student, I get an overview of events coming up within the next week.',
    status: Story.statuses[:closed],
    identifier: 'S-2'
).save(validate: false)
s3 = Story.new(
    title: 'As an IMI-Student, I can see events that will be important for me, e.g. the Projektvergabe, or the Showtime, well ahead.',
    status: Story.statuses[:closed],
    identifier: 'S-3'
).save(validate: false)
s4 = Story.new(
    title: 'As the Studiengangssprecher, I can also keep an overview of the planning status (date set, room booked, announced etc) for each listed event.',
    status: Story.statuses[:closed],
    identifier: 'S-4'
).save(validate: false)
s5 = Story.new(
    title: 'As a Student, I can filter events that are relevant for me (B/M, Semester).',
    status: Story.statuses[:closed],
    identifier: 'S-5'
).save(validate: false)
s6 = Story.new(
    title: 'I can see the IMI-Calendar in my favourite Calendar Application.',
    identifier: 'S-6'
).save(validate: false)
s7 = Story.new(
    title: 'S-1 and S-4 are only available when logged in as an Admin User.',
    status: Story.statuses[:closed],
    identifier: 'S-7'
).save(validate: false)
s8 = Story.new(
    title: 'As a SGS, I can edit the Categories of an event while editing the event.',
    status: Story.statuses[:closed],
    identifier: 'S-8'
).save(validate: false)
s9 = Story.new(
    title: 'As an SGS, I can delete Categories from an Category-Maintenance View listing all the Categories.',
    status: Story.statuses[:closed],
    identifier: 'S-9'
).save(validate: false)
s10 = Story.new(
    title: 'As an SGS, I can combine two categories into one.',
    status: Story.statuses[:closed],
    identifier: 'S-10'
).save(validate: false)
s11 = Story.new(
    title: 'As an SGS, I can edit the name of a category.',
    identifier: 'S-11'
).save(validate: false)
s12 = Story.new(
    title: 'Both as Student and SGS, I can log in with my FB4 Account (LDAP)',
    identifier: 'S-12'
).save(validate: false)
