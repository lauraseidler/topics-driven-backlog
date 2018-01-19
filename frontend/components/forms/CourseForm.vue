<template>
    <BForm
        @submit.prevent="submit"
        class="course-form">

        <BRow>
            <BCol md="4">
                <BFormGroup
                        label="Shorthand"
                        label-for="course-shorthand">

                    <BFormInput
                            id="course-shorthand"
                            v-model="data.short_title"
                            required/>
                </BFormGroup>
            </BCol>
            <BCol md="8">
                <BFormGroup
                        label="Title"
                        label-for="course-title">

                    <BFormInput
                            id="course-title"
                            v-model="data.title"
                            required/>
                </BFormGroup>
            </BCol>
        </BRow>


        <BFormGroup
                label="Link"
                label-for="course-hyperlink">

            <BFormInput
                    id="course-hyperlink"
                    v-model="data.hyperlink"/>
        </BFormGroup>

        <BFormGroup

                label="Semester"
                label-for="course-semester">

            <BFormSelect
                    v-if="!noSemester"
                    id="course-semester"
                    v-model="data.semester">

                <option :value="currentSemester.valueString">{{ currentSemester.fullString }}</option>
                <option :value="nextSemester.valueString">{{ nextSemester.fullString }}</option>
            </BFormSelect>

            <p v-else class="text-muted">You cannot edit the semester of a course. Please create a new course instead.</p>
        </BFormGroup>


        <BButton 
            type="submit" 
            variant="primary"
            :class="{ 'is-disabled': isInvalid }">Save</BButton>

        <BButton 
            type="button" 
            variant="grey" 
            @click="cancel">Cancel</BButton>
    </BForm>
</template>

<script>
import { required, url, requiredIf } from 'vuelidate/lib/validators';
import { current, next } from '@/helper/semester';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BFormSelect from '@bootstrap/form-select/form-select';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'CourseForm',
    components: { BForm, BFormGroup, BFormInput, BFormSelect, BRow, BCol, BButton },
    extends: BaseForm,
    props: {
        noSemester: {
            type: Boolean,
            default: false,
        }
    },
    computed: {

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
    validations: {
        data: {
            title: { required },
            hyperlink: { url },
            semester: {
                requiredIf: requiredIf(() => this.noSemester),
            },
        },
    },
};
</script>
