<template>
    <section id="stories">
        <h1>Stories</h1>

        <h2>New story</h2>

        <b-form @submit="saveStory" class="mb-5">
            <b-form-group label="Title" label-for="story-title">
                <b-form-input id="story-title" v-model="newStory.title" required></b-form-input>
            </b-form-group>

            <b-form-group label="Description" label-for="story-description">
                <b-form-textarea id="story-description" v-model="newStory.description" required></b-form-textarea>
            </b-form-group>

            <b-button type="submit" variant="primary" :disabled="$v.newStory.$invalid">Save</b-button>
        </b-form>

        <h2>Existing stories</h2>
        <b-table :items="$store.state.stories.data" :fields="['title', 'description']"></b-table>
    </section>
</template>

<script>
    import { required } from 'vuelidate/lib/validators';

    export default {
        data() {
            return {
                newStory: {},
            };
        },
        methods: {
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
        },
        validations: {
            newStory: {
                title: { required },
            },
        },
    };
</script>

<style scoped>

</style>
