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
                        <ul 
                            class="list-unstyled" 
                            v-if="projects.length">

                            <ProjectItem
                                class="mb-2"
                                v-for="project in projects"
                                :data="project"
                                :key="project.id"/>
                        </ul>

                        <p v-else>No projects in this course yet.</p>

                        <ProjectForm
                            v-if="showProjectForm"
                            v-model="newProject"
                            @cancel="showProjectForm = false"
                            @submit="addProject"/>

                        <BButton 
                            v-else
                            type="button" 
                            variant="primary" 
                            @click="showProjectForm = true">Add project</BButton>
                    </BTab>
                    <BTab title="Topics">
                        <ul
                            class="list-unstyled"
                            v-if="topics.length">

                            <TopicItem
                                class="mb-2"
                                v-for="topic in topics"
                                :data="topic"
                                :key="topic.id"/>
                        </ul>

                        <p v-else>No topics in this course yet.</p>

                        <TopicForm
                                v-if="showTopicForm"
                                v-model="newTopic"
                                @cancel="showTopicForm = false"
                                @submit="addTopic"/>

                        <BButton
                                v-else
                                type="button"
                                variant="primary"
                                @click="showTopicForm = true">Add topic</BButton>
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
import ProjectForm from '@/components/forms/ProjectForm';
import ProjectItem from '@/components/elements/ProjectItem';
import TopicForm from '@/components/forms/TopicForm';
import TopicItem from '@/components/elements/TopicItem';
import { info } from '@/helper/semester';

export default {
    components: {
        SprintCollectionForm,
        SprintForm,
        ProjectForm,
        TopicForm,
        SprintItem,
        ProjectItem,
        TopicItem,
        NotFound,
        BCard,
        BTabs,
        BTab,
        BButton,
    },
    data() {
        return {
            showSprintForm: false,
            showCollectionForm: false,
            showProjectForm: false,
            showTopicForm: false,
            newSprint: this.$store.getters['sprints/template'](),
            newCollection: {},
            newProject: this.$store.getters['projects/template'](),
            newTopic: this.$store.getters['topics/template'](),
        };
    },
    computed: {
        /**
         * Course to display
         * @returns {object}
         */
        course() {
            return this.$store.getters['courses/byId'](
                parseInt(this.$route.params.id, 10)
            );
        },

        /**
         * Sprints in course sorted by start date
         * @returns {array}
         */
        sprints() {
            return this.course
                ? this.$store.getters['sprints/all'](this.course.id)
                    .sort((a, b) => a.start_date > b.start_date)
                : [];
        },

        /** 
         * Projects in course
         * @returns {array}
         */
        projects() {
            return this.course
                ? this.$store.getters['projects/all'](this.course.id)
                : [];
        },

        /**
         * Topics in course
         * @returns {array}
         */
        topics() {
            return this.course
                ? this.$store.getters['topics/all'](this.course.id)
                : [];
        },
    },
    methods: {
        /**
         * Add a sprint to the given course
         */
        async addSprint() {
            await this.$store.dispatch('sprints/create', {
                parentId: this.course.id,
                ...this.newSprint,
            });

            this.newSprint = this.$store.getters['sprints/template']();

            // TODO handle errors in UI
        },

        /**
         * Add a sprint collection to the given course
         */
        async addCollection() {
            await this.$store.dispatch('sprints/createCollection', {
                parentId: this.course.id,
                collection: this.newCollection,
            });

            this.newCollection = {};

            // TODO handle errors in UI
        },

        async addProject() {
            await this.$store.dispatch('projects/create', {
                parentId: this.course.id,
                ...this.newProject,
            });

            this.newProject = this.$store.getters['projects/template']();

            // TODO handle errors in UI
        },

        async addTopic() {
            await this.$store.dispatch('topics/create', {
                parentId: this.course.id,
                ...this.newTopic,
            });

            this.newTopic = this.$store.getters['topics/template']();

            // TODO handle errors in UI
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