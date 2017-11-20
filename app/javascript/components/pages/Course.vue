<template>
    <section id="course">
        <template v-if="course">
            <h1>
                {{ course.title }}
                <small class="text-muted">{{ getSemesterInfo(course.semester_type, course.semester_year)</small>
            </h1>

            <p>
                <a v-if="story.hyperlink" :href="course.hyperlink">{{ course.hyperlink }}</a>
            </p>

            <h2>Sprints</h2>

            <ul>
                <li v-for="sprint in sprints">{{ sprint.name }} ({{sprint.start_date}} - {{sprint.end_date}})
                </li>
            </ul>

            <b-form v-if="showForm" @submit="addSprint">
                <b-form-group label="Name" label-for="sprint-name">
                    <b-form-input id="sprint-name" v-model="newSprint.name" required></b-form-input>
                </b-form-group>

                <b-form-group label="Start date" label-for="sprint-start-date">
                    <b-form-input id="sprint-start-date" type="date" v-model="newSprint.start_date"
                                  required></b-form-input>
                </b-form-group>

                <b-form-group label="End date" label-for="sprint-end-date">
                    <b-form-input id="sprint-end-date" type="date" v-model="newSprint.end_date" required></b-form-input>
                </b-form-group>

                <b-button type="submit" variant="primary" :disabled="$v.newSprint.$invalid">Save</b-button>
                <b-button type="button" variant="secondary" @click="showForm = false">Cancel</b-button>
            </b-form>

            <b-button v-else type="button" variant="primary" @click="showForm = true">Add sprint</b-button>

        </template>
        <not-found v-else></not-found>
    </section>
</template>

<script>
    import {required} from 'vuelidate/lib/validators';
    import smallerOrEqualThan from '../../validators/smallerOrEqualThan';
    import largerOrEqualThan from '../../validators/largerOrEqualThan';
    import NotFound from "../elements/NotFound.vue";
    import {info} from '../../helper/semester';

    export default {
        components: {NotFound},
        data() {
            return {
                showForm: false,
                newSprint: {},
            };
        },
        computed: {
            course() {
                return this.$store.getters['courses/byId'](this.$route.params.id);
            },
            sprints() {
                return this.course.sprints.sort((a, b) => a.start_date < b.start_date);
            }
        },
        methods: {
            /**
             * Add a sprint to the given course
             */
            addSprint() {
                if (this.$v.newSprint.$invalid) {
                    this.$v.newSprint.$touch();
                    return;
                }

                this.$store.dispatch('courses/addSprint', {
                    id: this.course.id,
                    sprint: this.newSprint
                }).then(() => {
                    this.newSprint = {};
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
            },
        },
        validations: {
            newSprint: {
                name: {required},
                start_date: {
                    required,
                    smallerThanEnd: smallerOrEqualThan('end_date')
                },
                end_date: {
                    required,
                    largerThanStart: largerOrEqualThan('start_date')
                },
            },
        },
    };
</script>

<style scoped>

</style>
