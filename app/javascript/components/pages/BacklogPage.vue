<template>
    <section id="backlog-page">
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
                <tr is="story" v-for="story in stories" :key="story.id" :data="story" class="mb-3" view="backlog"></tr>
            </tbody>
        </table>

        <story-form v-if="showForm" v-model="newStory" @cancel="showForm = false" @submit="save"></story-form>
        <b-button v-else type="button" variant="primary" @click="showForm = true">Add story</b-button>
    </section>
</template>

<script>
    import {required, numeric, minValue} from 'vuelidate/lib/validators';
    import Story from "../elements/Story.vue";
    import StoryForm from "../forms/StoryForm.vue";

    export default {
        components: {StoryForm, Story},
        data() {
            return {
                showForm: false,
                newStory: {},
            };
        },
        computed: {
            stories() {
                return this.$store.getters['stories/all']
                    .filter(s => s.status === this.$store.state.stories.STATUS.OPEN)
                    .sort((a, b) => a.position - b.position);
            },
        },
        methods: {
            /**
             * Save current form state as new story
             */
            save() {
                this.$store.dispatch('stories/save', {
                    story: this.newStory
                }).then(() => {
                    this.newStory = {};
                });
            },

            /**
             * Save new position of dragged story
             * @param evt
             */
            saveOrder(evt) {
                const story = this.stories[evt.oldIndex];

                if (!story) {
                    return;
                }

                this.$store.dispatch('stories/patch', {
                    id: story.id,
                    field: 'position',
                    value: evt.newIndex + 1, // act_as_list is 1-indexed
                    fetch: true,
                });
            },
        }
    };
</script>

<style scoped>

</style>
