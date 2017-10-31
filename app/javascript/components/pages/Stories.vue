<template>
    <section id="stories">
        <h1>Stories</h1>

        <h2>New story</h2>

        <form>
            <p>
                <label for="story-title">Title</label> <br>
                <input type="text" id="story-title" v-model="newStory.title">
            </p>
            <p>
                <label for="story-description">Title</label> <br>
                <textarea id="story-description" v-model="newStory.description"></textarea>
            </p>
            <p>
                <button :disabled="$v.newStory.$invalid" @click="saveStory()">Save</button>
            </p>
        </form>

        <table>
            <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="story in $store.state.stories.data">
                <td>{{ story.title}}</td>
                <td>{{ story.description }}</td>
            </tr>
            </tbody>
        </table>
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
