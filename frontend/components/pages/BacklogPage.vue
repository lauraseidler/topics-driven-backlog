<template>
    <section id="backlog-page">
        <h2 class="h4 text-muted">{{ course.title}} - {{ project.title}}</h2>
        <h1>Backlog</h1>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Story&nbsp;points</th>
                    <th>Operations</th>
                </tr>
            </thead>
            <tbody v-sortable="{handle: '.js-drag-drop', onEnd: saveOrder}" >
                <tr
                    is="StoryItem"
                    v-for="story in stories"
                    :key="story.id"
                    :data="story"
                    view="backlog"/>
            </tbody>
        </table>

        <StoryForm
            v-if="showForm"
            v-model="newStory"
            @cancel="showForm = false"
            @submit="save"/>

        <BButton
            v-else
            type="button"
            variant="primary"
            @click="showForm = true">Add story</BButton>
    </section>
</template>

<script>
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import BButton from '@bootstrap/button/button';

export default {
    components: { StoryForm, StoryItem, BButton },
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
        };
    },
    computed: {
        course() {
            return this.$route.params.courseId
                ? this.$store.getters['courses/byId'](parseInt(this.$route.params.courseId, 10))
                : null;
        },

        project() {
            return this.course
                ? this.$store.getters['projects/byId'](this.course.id, parseInt(this.$route.params.id, 10))
                : null;
        },

        /**
         * All stories in backlog that are open and not already in sprints, sorted by position
         * @returns {array}
         */
        stories() {
            return this.project
                ? this.$store.getters['stories/all'](this.project.id)
                    .filter(s => !s.sprint_id && s.status === this.$store.state.stories.STATUS.OPEN)
                    .sort((a, b) => a.position - b.position)
                : [];
        },
    },
    methods: {
        init() {
            if (this.project) {
                this.$store.dispatch('projects/init', {
                    id: this.project.id,
                    parentId: this.course.id
                });
            }
        },
        /**
         * Save current form state as new story
         */
        async save() {
            await this.$store.dispatch('stories/create', {
                parentId: this.project.id,
                ...this.newStory
            });

            this.newStory = this.$store.getters['stories/template']();

            // TODO handle errors in UI
        },


        /**
         * Save new position of dragged story
         * @param {Event} evt
         */
        async saveOrder(evt) {
            const story = this.stories[evt.oldIndex];

            if (!story) {
                return;
            }

            await this.$store.dispatch('stories/update', {
                id: story.id,
                parentId: this.project.id,
                position: evt.newIndex + 1, // act_as_list is 1-indexed
            });

            await this.$store.dispatch('projects/fetch', {
                id: this.project.id,
                parentId: this.course.id
            });

            // TODO handle errors in UI
        },
    },

    created() {
        this.init();
    },

    watch: {
        $route: 'init',
        course: 'init',
    },
};
</script>