<template>
    <section id="course-page">
        <template v-if="course">
            <h1>
                {{ course.title }}
                <small class="text-muted">{{ getSemesterInfo(course.semester_type, course.semester_year).fullString }}
                </small>
            </h1>

            <p v-if="course.hyperlink" >
                <a :href="course.hyperlink">{{ course.hyperlink }}</a>
            </p>

            <BCard no-body>
                <BTabs card>
                    <BTab title="Projects">
                        <p>No projects in this course yet.</p>
                    </BTab>
                    <BTab title="Topics">
                        <p>No topics in this course yet.</p>
                    </BTab>
                    <BTab title="Sprints">
                        <ul 
                            class="list-unstyled" 
                            v-if="sprints.length">

                            <SprintItem 
                                class="mb-2" 
                                v-for="sprint in sprints" 
                                :data="sprint" 
                                :key="sprint.id"/>
                        </ul>

                        <p v-else>No sprints in this course yet.</p>

                        <SprintForm 
                            v-if="showSprintForm" 
                            v-model="newSprint" 
                            @cancel="showSprintForm = false" 
                            @submit="addSprint"/>

                        <SprintCollectionForm 
                            v-else-if="showCollectionForm" 
                            v-model="newCollection"
                            @cancel="showCollectionForm = false"
                            @submit="addCollection"/>

                        <template v-else>
                            <BButton 
                                type="button" 
                                variant="primary" 
                                @click="showSprintForm = true">Add sprint</BButton>
                            
                            <BButton 
                                type="button" 
                                variant="primary" 
                                @click="showCollectionForm = true">Add multiple sprints</BButton>
                        </template>
                    </BTab>
                </BTabs>
            </BCard>
        </template>
        <NotFound v-else/>
    </section>
</template>

<script>
import BCard from '@bootstrap/card/card';
import BTabs from '@bootstrap/tabs/tabs';
import BTab from '@bootstrap/tabs/tab';
import BButton from '@bootstrap/button/button';
import NotFound from '@/components/elements/NotFound';
import SprintItem from '@/components/elements/SprintItem';
import SprintForm from '@/components/forms/SprintForm';
import SprintCollectionForm from '@/components/forms/SprintCollectionForm';
import { info } from '@/helper/semester';

export default {
    components: { SprintCollectionForm, SprintForm, SprintItem, NotFound, BCard, BTabs, BTab, BButton },
    data() {
        return {
            showSprintForm: false,
            showCollectionForm: false,
            newSprint: {},
            newCollection: {},
        };
    },
    computed: {
        /**
         * Course to display
         * @returns {object}
         */
        course() {
            return this.$store.getters['courses/byId'](parseInt(this.$route.params.id, 10));
        },
        /**
         * Sprints in course sorted by start date
         * @returns {array}
         */
        sprints() {
            return this.course.sprints ? this.course.sprints.slice().sort((a, b) => a.start_date > b.start_date) : [];
        },
    },
    methods: {
        /**
         * Add a sprint to the given course
         */
        addSprint() {            
            this.$store
                .dispatch('sprints/save', {
                    course_id: this.course.id,
                    sprint: this.newSprint,
                })
                .then(() => {
                    this.newSprint = {};
                });
        },

        /**
         * Add a sprint collection to the given course
         */
        addCollection() {
            this.$store
                .dispatch('sprints/saveCollection', {
                    course_id: this.course.id,
                    collection: this.newCollection,
                })
                .then(() => {
                    this.newCollection = {};
                });
        },

        /**
         * Semester info for given type and year
         * @param {string} type
         * @param {string} year
         * @returns {{semesterStart: *, semester: string, year: number, fullString: string, valueString: string}}
         */
        getSemesterInfo(type, year) {
            return info(type, year);
        },
    },
};
</script>