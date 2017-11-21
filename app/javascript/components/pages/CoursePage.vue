<template>
    <section id="course">
        <template v-if="course">
            <h1>
                {{ course.title }}
                <small class="text-muted">{{ getSemesterInfo(course.semester_type, course.semester_year).fullString }}
                </small>
            </h1>

            <p>
                <a v-if="course.hyperlink" :href="course.hyperlink">{{ course.hyperlink }}</a>
            </p>

            <h2>Sprints</h2>

            <ul class="list-unstyled" v-if="sprints.length">
                <sprint class="mb-2" v-for="sprint in sprints" :data="sprint" :key="sprint.id"></sprint>
            </ul>

            <p v-else>No sprints in this course yet.</p>

            <sprint-form v-if="showForm" v-model="newSprint" @cancel="showForm = false" @submit="addSprint"></sprint-form>

            <b-button v-else type="button" variant="primary" @click="showForm = true">Add sprint</b-button>

        </template>
        <not-found v-else></not-found>
    </section>
</template>

<script>
    import NotFound from "../elements/NotFound.vue";
    import {info} from '../../helper/semester';
    import Sprint from "../elements/Sprint.vue";
    import SprintForm from "../forms/SprintForm.vue";

    export default {
        components: {SprintForm, Sprint, NotFound},
        data() {
            return {
                showForm: false,
                newSprint: {},
            };
        },
        computed: {
            course() {
                return this.$store.getters['courses/byId'](parseInt(this.$route.params.id, 10));
            },
            sprints() {
                return this.course.sprints ? this.course.sprints.sort((a, b) => a.start_date > b.start_date) : [];
            }
        },
        methods: {
            /**
             * Add a sprint to the given course
             */
            addSprint() {
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
    };
</script>

<style scoped>

</style>
