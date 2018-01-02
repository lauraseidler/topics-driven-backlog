<template>
    <p>BaseProjectAwarePage can't be instantiated!</p>

</template>

<script>
    export default {
        name: 'BaseProjectAwarePage',
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
        },
        methods: {
            initData() {
                if (this.project) {
                    this.$store.dispatch('projects/init', {
                        id: this.project.id,
                        parentId: this.course.id
                    });
                }
            },
        },
        created() {
            this.initData();
        },
        watch: {
            $route: 'initData',
            course: 'initData',
        },
    };
</script>

<style scoped>

</style>