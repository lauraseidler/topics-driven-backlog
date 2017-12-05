<template>
    <section id="courses">
        <h1>Courses</h1>

        <ul v-if="courses.length" class="list-unstyled">
            <li class="card mb-3" v-for="course in courses" :key="course.id">
                <div class="card-body">
                    <router-link :to="`/courses/${course.id}`" class="h4 card-title link-unstyled">
                        {{ course.short_title }}
                    </router-link>

                    <h5 class="h6 text-muted card-subtitle mt-0">
                        {{ course.title }} ({{ getSemesterInfo(course.semester_type, course.semester_year).fullString }})
                    </h5>

                    <p class="card-text mt-2" v-if="course.hyperlink">
                        <a :href="course.hyperlink">{{ course.hyperlink }}</a>
                    </p>
                </div>
            </li>
        </ul>

        <p v-else>No courses yet.</p>

        <b-form v-if="showForm" @submit="saveCourse">
            <b-row>
                <b-col md="4">
                    <b-form-group label="Shorthand" label-for="course-shorthand">
                        <b-form-input id="course-shorthand" v-model="newCourse.short_title" required></b-form-input>
                    </b-form-group>
                </b-col>
                <b-col md="8">
                    <b-form-group label="Title" label-for="course-title">
                        <b-form-input id="course-title" v-model="newCourse.title" required></b-form-input>
                    </b-form-group>
                </b-col>
            </b-row>


            <b-form-group label="Link" label-for="course-hyperlink">
                <b-form-input id="course-hyperlink" v-model="newCourse.hyperlink"></b-form-input>
            </b-form-group>

            <b-form-group label="Semester" label-for="course-semester">
                <b-form-select id="course-semester" v-model="newCourse.semester">
                    <option :value="currentSemester.valueString">{{ currentSemester.fullString }}</option>
                    <option :value="nextSemester.valueString">{{ nextSemester.fullString }}</option>
                </b-form-select>
            </b-form-group>

            <b-button type="submit" variant="primary" :disabled="$v.newCourse.$invalid">Save</b-button>
            <b-button type="button" variant="secondary" @click="showForm = false">Cancel</b-button>
        </b-form>

        <b-button v-else type="button" variant="primary" @click="showForm = true">Add course</b-button>
    </section>
</template>

<script>
    import {required, url} from 'vuelidate/lib/validators';
    import smallerOrEqualThan from '../../validators/smallerOrEqualThan';
    import largerOrEqualThan from '../../validators/largerOrEqualThan';
    import {current, next, info} from '../../helper/semester';

    export default {
        data() {
            return {
                showForm: false,
                newCourse: this.$store.getters['courses/new'],
            };
        },
        computed: {
            courses() {
                return this.$store.getters['courses/all'];
            },
            currentSemester() {
                return current();
            },
            nextSemester() {
                return next();
            }
        },
        methods: {
            /**
             * Save current form state as new story
             */
            saveCourse() {
                if (this.$v.newCourse.$invalid) {
                    this.$v.newCourse.$touch();
                    return;
                }

                this.$store.dispatch('courses/save', {
                    course: this.newCourse
                }).then(() => {
                    this.newCourse = this.$store.getters['courses/new'];
                });
            },

            /**
             * Semester info for given type and year
             * @param type
             * @param year
             * @returns {{semesterStart: *, semester: string, year: number, fullString: string, valueString: string}}
             */
            getSemesterInfo(type, year) {
                return info(type, year);
            }
        },
        validations: {
            newCourse: {
                title: {required},
                hyperlink: {url},
                semester: {required},
            },
        },
    };
</script>

<style scoped>

</style>
