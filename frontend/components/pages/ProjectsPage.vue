<template>
    <section id="projects-page">
        <h1>Projects</h1>

        <div
            v-for="course in courses"
            class="mb-3">

            <h2>{{ course.title }}</h2>

            <ul :class="[$style.list, 'list-unstyled', 'mb-5']">
                <ProjectItem
                        v-for="project in projects(course.id)"
                        :key="project.id"
                        :data="project"
                        view="use"/>

                <ProjectItem
                    view="new"
                    :class="$style.new"
                    :data="newProject"
                    @submit="addProject(course.id, ...arguments)"/>
            </ul>
        </div>
    </section>
</template>

<script>
import ProjectItem from '@/components/elements/ProjectItem';

export default {
    name: 'ProjectsPage',
    components: { ProjectItem },
    data() {
        return {
            newProject: this.$store.getters['projects/template'](),
        };
    },
    computed: {
        courses() {
            return this.$store.getters['courses/all'];
        },
    },
    methods: {
        projects(courseId) {
            return this.$store.getters['projects/all'](courseId);
        },

        async addProject(courseId, project) {
            await this.$store.dispatch('projects/create', {
                parentId: courseId,
                ...project,
            });

            this.newProject =  this.$store.getters['projects/template']();


            // TODO handle errors in UI
        },
    },
};
</script>

<style lang="scss" module>
    .list {
        display: grid;
        grid-gap: 8px;
        grid-template-columns: 1fr 1fr 1fr 1fr;
        grid-auto-rows: minmax(200px, 1fr);
    }

    .new {
        color: rgba(0, 0, 0, .125);
        border: 1px solid currentColor;

        &:hover {
            color: rgba(0, 0, 0, .25);
        }
    }
</style>