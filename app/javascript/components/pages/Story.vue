<template>
    <section id="story">
        <template v-if="story">
            <h1>
                {{ story.title }}
                <small class="text-muted">{{ story.identifier }}</small>
            </h1>

            <p v-if="story.description">
                {{ story.description }}
            </p>
        </template>
        <not-found v-else></not-found>
    </section>
</template>

<script>
    import NotFound from "../elements/NotFound.vue";

    export default {
        components: {NotFound},
        data() {
            return {};
        },
        computed: {
            story() {
                return this.$store.getters['stories/byIdentifier'](this.$route.params.identifier);
            }
        },
    };
</script>

<style scoped>

</style>
