<template>
    <section id="story-page">
        <template v-if="story">
            <h1>
                {{ story.title }}
                <small class="text-muted">{{ story.identifier }}</small>
            </h1>

            <p v-if="story.description">
                {{ story.description }}
            </p>
        </template>
        <NotFound v-else/>
    </section>
</template>

<script>
import NotFound from '@/components/elements/NotFound';

export default {
    components: { NotFound },
    data() {
        return {};
    },
    computed: {
        /**
         * Story to display
         * @returns {object}
         */
        story() {
            return this.$store.getters['stories/byIdentifier'](
                this.$route.params.identifier
            );
        },
    },
};
</script>