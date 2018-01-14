<template>
    <p>BaseProjectAwarePage can't be instantiated!</p>

</template>

<script>
    export default {
        name: 'BaseProjectAwarePage',
        computed: {
            course() {
                return this.project
                    ? this.$store.getters['courses/byId'](this.project.course_id)
                    : null;
            },

            project() {
                return this.$store.getters['projects/byId'](parseInt(this.$route.params.id, 10));
            },
        },
        methods: {
            initData() {
                if (this.project && this.course) {
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