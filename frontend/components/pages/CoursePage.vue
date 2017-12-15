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

            <b-card no-body>
                <b-tabs card>
                    <b-tab title="Projects">
                        <p>No projects in this course yet.</p>
                    </b-tab>
                    <b-tab title="Topics">
                        <p>No topics in this course yet.</p>
                    </b-tab>
                    <b-tab title="Sprints">
                        <ul class="list-unstyled" v-if="sprints.length">
                            <sprint class="mb-2" v-for="sprint in sprints" :data="sprint" :key="sprint.id"></sprint>
                        </ul>

                        <p v-else>No sprints in this course yet.</p>

                        <sprint-form v-if="showSprintForm" v-model="newSprint" @cancel="showSprintForm = false" @submit="addSprint"></sprint-form>

                        <sprint-collection-form v-else-if="showCollectionForm" v-model="newCollection"
                                                @cancel="showCollectionForm = false"
                                                @submit="addCollection"></sprint-collection-form>
                        <template v-else>
                            <b-button type="button" variant="primary" @click="showSprintForm = true">Add sprint</b-button>
                            <b-button type="button" variant="primary" @click="showCollectionForm = true">Add multiple sprints</b-button>
                        </template>
                    </b-tab>
                </b-tabs>
            </b-card>
        </template>
        <not-found v-else></not-found>
    </section>
</template>

<script>
    import NotFound from "../elements/NotFound.vue";
    import {info} from '../../helper/semester';
    import Sprint from "../elements/Sprint.vue";
    import SprintForm from "../forms/SprintForm.vue";
    import SprintCollectionForm from "../forms/SprintCollectionForm.vue";

    export default {
        components: {SprintCollectionForm, SprintForm, Sprint, NotFound},
        data() {
            return {
                showSprintForm: false,
                showCollectionForm: false,
                newSprint: {},
                newCollection: {},
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
             * Add a sprint collection to the given course
             */
            addCollection() {
                this.$store.dispatch('courses/addSprintCollection', {
                    id: this.course.id,
                    collection: this.newCollection
                }).then(() => {
                    this.newCollection = {};
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
