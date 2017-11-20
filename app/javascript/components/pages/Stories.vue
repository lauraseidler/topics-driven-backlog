<template>
    <section id="stories">
        <h1>Backlog</h1>

        <ul v-sortable="{handle: '.js-drag-drop', onEnd: saveOrder}" class="mt-3 pl-0">
            <story class="mb-3" v-for="story in stories" :data="story" :key="story.id">
                <template slot="drag-handle">
                    <span class="js-drag-drop float-right p-1">
                        <icon name="bars" label="Drag and drop to change order"></icon>
                    </span>
                </template>
            </story>
        </ul>

        <b-form v-if="showForm" @submit="saveStory">
            <b-row>
                <b-col md="10">
                    <b-form-group label="Story *" label-for="story-title">
                        <b-form-input id="story-title" v-model="newStory.title" required></b-form-input>
                    </b-form-group>
                </b-col>
                <b-col md="2">
                    <b-form-group label="Story points" label-for="story-points">
                        <b-form-input id="story-points" type="number" min="0" v-model="newStory.points"></b-form-input>
                    </b-form-group>
                </b-col>
            </b-row>

            <b-form-group label="Notes" label-for="story-description">
                <b-form-textarea id="story-description" v-model="newStory.description"></b-form-textarea>
            </b-form-group>

            <b-button type="submit" variant="primary" :disabled="$v.newStory.$invalid">Save</b-button>
            <b-button type="button" variant="secondary" @click="showForm = false">Cancel</b-button>
        </b-form>

        <b-button v-else type="button" variant="primary" @click="showForm = true">Add story</b-button>
    </section>
</template>

<script>
    import {required, numeric, minValue} from 'vuelidate/lib/validators';
    import Story from "../elements/Story.vue";

    export default {
        components: {Story},
        data() {
            return {
                showForm: false,
                newStory: {},
            };
        },
        computed: {
            stories() {
                return this.$store.getters['stories/all'];
            }
        },
        methods: {
            /**
             * Save current form state as new story
             */
            saveStory() {
                if (this.$v.newStory.$invalid) {
                    this.$v.newStory.$touch();
                    return;
                }

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
                this.$store.dispatch('stories/reorder', {
                    oldIndex: evt.oldIndex,
                    newIndex: evt.newIndex,
                });
            },
        },
        validations: {
            newStory: {
                title: {required},
                points: {numeric, minValue: minValue(0)}
            },
        },
    };
</script>

<style scoped>

</style>
