<template>
    <section id="courses-page">
        <h1>Courses</h1>

        <ul 
            v-if="courses.length" 
            class="list-unstyled">

            <li 
                class="card mb-3" 
                v-for="course in courses" 
                :key="course.id">

                <div class="card-body">
                    <router-link 
                        :to="`/courses/${course.id}-${slugify(course.title)}`"
                        class="h4 card-title link-unstyled">
                        {{ course.short_title }}
                    </router-link>

                    <h5 class="h6 text-muted card-subtitle mt-0">
                        {{ course.title }} ({{ getSemesterInfo(course.semester_type, course.semester_year).fullString }})
                    </h5>

                    <p 
                        class="card-text mt-2" 
                        v-if="course.hyperlink">

                        <a :href="course.hyperlink">{{ course.hyperlink }}</a>
                    </p>
                </div>
            </li>
        </ul>

        <p v-else>No courses yet.</p>

        <BForm 
            v-if="showForm" 
            @submit="saveCourse">

            <BRow>
                <BCol md="4">
                    <BFormGroup 
                        label="Shorthand" 
                        label-for="course-shorthand">

                        <BFormInput 
                            id="course-shorthand" 
                            v-model="newCourse.short_title" 
                            required/>
                    </BFormGroup>
                </BCol>
                <BCol md="8">
                    <BFormGroup 
                        label="Title" 
                        label-for="course-title">

                        <BFormInput 
                            id="course-title" 
                            v-model="newCourse.title" 
                            required/>
                    </BFormGroup>
                </BCol>
            </BRow>


            <BFormGroup 
                label="Link" 
                label-for="course-hyperlink">

                <BFormInput 
                    id="course-hyperlink" 
                    v-model="newCourse.hyperlink"/>
            </BFormGroup>

            <BFormGroup 
                label="Semester" 
                label-for="course-semester">

                <BFormSelect 
                    id="course-semester" 
                    v-model="newCourse.semester">

                    <option :value="currentSemester.valueString">{{ currentSemester.fullString }}</option>
                    <option :value="nextSemester.valueString">{{ nextSemester.fullString }}</option>
                </BFormSelect>
            </BFormGroup>

            <BButton 
                type="submit" 
                variant="primary" 
                :disabled="$v.newCourse.$invalid">Save</BButton>

            <BButton 
                type="button" 
                variant="secondary" 
                @click="showForm = false">Cancel</BButton>
        </BForm>

        <BButton 
            v-else 
            type="button" 
            variant="primary" 
            @click="showForm = true">Add course</BButton>
    </section>
</template>

<script>
import { required, url } from 'vuelidate/lib/validators';
import { current, next, info } from '@/helper/semester';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BFormSelect from '@bootstrap/form-select/form-select';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';
import BButton from '@bootstrap/button/button';

export default {
    components: { BForm, BFormGroup, BFormInput, BFormSelect, BRow, BCol, BButton },
    data() {
        return {
            showForm: false,
            newCourse: this.$store.getters['courses/template'](),
        };
    },
    computed: {
        /**
         * All courses
         * @returns {array}
         */
        courses() {
            return this.$store.getters['courses/all'];
        },

        /**
         * Current semester info
         * @returns {object}
         */
        currentSemester() {
            return current();
        },

        /**
         * Next semester info
         * @returns {object}
         */
        nextSemester() {
            return next();
        },
    },
    methods: {
        /**
         * Save current form state as new story
         */
        async saveCourse() {
            if (this.$v.newCourse.$invalid) {
                this.$v.newCourse.$touch();
                return;
            }

            const semesterSplit = this.newCourse.semester.split('*');
            this.newCourse.semester_type = semesterSplit[0];
            this.newCourse.semester_year = parseInt(semesterSplit[1], 10);

            await this.$store.dispatch('courses/create', this.newCourse);

            this.newCourse = this.$store.getters['courses/template']();

            // TODO handle errors in UI
        },

        /**
         * Semester info for given type and year
         * @param {string} type
         * @param {string} year
         * @returns {{semesterStart: *, semester: string, year: number, fullString: string, valueString: string}}
         */
        getSemesterInfo(type, year) {
            return info(type, year);
        },

        slugify(text) {
            return text.toString().toLowerCase()
                .replace(/\s+/g, '-')           // Replace spaces with -
                .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
                .replace(/\-\-+/g, '-')         // Replace multiple - with single -
                .replace(/^-+/, '')             // Trim - from start of text
                .replace(/-+$/, '');            // Trim - from end of text
        },
    },
    validations: {
        newCourse: {
            title: { required },
            hyperlink: { url },
            semester: { required },
        },
    },
};
</script>