<template>
    <section id="projects-page">
        <h1>
            Projects
            <small class="text-muted">by course</small>
        </h1>

        <div
            v-for="course in courses"
            :key="course.id"
            class="mb-3">

            <hr class="mt-4 mb-5">

            <BRow>
                <BCol lg="4">
                    <router-link 
                        class="h2" 
                        :to="`/courses/${course.id}-${slugify(course.title)}`">
                        
                        {{ course.short_title }} <br>
                        <small class="text-muted">
                            {{ course.title }}
                        </small>
                    </router-link>
                </BCol>
                <BCol lg="8">
                    <ul :class="[$style.list, 'list-unstyled', 'mb-5']">
                        <ProjectItem
                            v-for="project in projects(course.id)"
                            :key="project.id"
                            :data="project"/>

                        <ProjectItem
                            v-if="course && course.permissions.projects.create && !isEnrolledToProjectInCourse(course.id)"
                            view="new"
                            :class="$style.new"
                            :data="newProject"
                            :course-id="course.id"/>
                    </ul>
                </BCol>
            </BRow>
        </div>
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
        courses() {
            return this.$store.getters['courses/all'];
        },
    },
    methods: {
        slugify,

        projects(courseId) {
            return this.$store.getters['projects/all'](courseId);
        },

        isEnrolledToProjectInCourse(courseId) {
            return this.projects(courseId).filter(
                p => p.user_ids && p.user_ids.indexOf(this.$store.state.user.id) > -1
            ).length > 0;
        },
    },
};
</script>

<style lang="scss" module>
    .list {
        display: grid;
        grid-gap: 8px;
        grid-template-columns: 1fr 1fr ;
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