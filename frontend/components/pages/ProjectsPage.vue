<template>
    <section id="projects-page">
        <h1>Projects</h1>

        <ul class="list-unstyled">
            <ProjectItem 
                v-for="project in projects" 
                :key="project.id"
                :data="project"
                view="use"
                class="mb-2" /> 
        </ul>
    </section>
</template>

<script>
import ProjectItem from '@/components/elements/ProjectItem';

export default {
    name: 'ProjectsPage',
    components: { ProjectItem },
    computed: {
        projects() {
            return this.$store.getters['projects/all'];
        },
    },
};
</script>
