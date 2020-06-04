<template>
    <section id="projects-page">
        <h1>
            My Projects
        </h1>

        <ul
            :class="[$style.list, 'list-unstyled', 'mb-5']"
            v-if="myProjects.length">

            <ProjectItem
                v-for="project in myProjects"
                :display-course="true"
                :key="project.id"
                :data="project"/>
        </ul>

        <p v-else>No projects yet.</p>
    </section>
</template>

<script>
import ProjectItem from '@/components/elements/ProjectItem';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';
import { slugify } from '@/helper/util';

export default {
    name: 'ProjectsPage',
    components: { ProjectItem, BRow, BCol },
    data() {
        return {
            newProject: this.$store.getters['projects/template'](),
        };
    },
    computed: {
        allCourses() {
            return this.$store.getters['courses/all'];
        },

        myProjects() {
            return this.allCourses
                .filter(c => this.isEnrolledToProjectInCourse(c.id))
                .map(c => this.enrolledProjectsInCourse(c.id)[0]);
        },
    },
    methods: {
        slugify,

        projects(courseId) {
            return this.$store.getters['projects/all'](courseId);
        },

        enrolledProjectsInCourse(courseId) {
            return this.projects(courseId).filter(
                p => p.user_ids && p.user_ids.indexOf(this.$store.state.user.id) > -1
            );
        },

        isEnrolledToProjectInCourse(courseId) {
            return this.enrolledProjectsInCourse(courseId).length > 0;
        },
    },
};
</script>

<style lang="scss" module>
    @import "../../style/mixins.scss";

    .list {
        display: grid;
        grid-gap: 8px;
        grid-template-columns: 1fr 1fr ;
    }

    .new {
        color: rgba(0, 0, 0, .125);
        border: 1px solid currentColor;

        &:hover {
            color: rgba(0, 0, 0, .25);
        }
    }

  @include mobile {
    .list {
      grid-template-columns: 1fr;
    }
  }
</style>
