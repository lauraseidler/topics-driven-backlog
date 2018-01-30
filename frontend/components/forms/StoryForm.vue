<template>
    <BForm 
        @submit.prevent="submit" 
        class="story-form">

        <BRow>
            <BCol md="10">
                <BFormGroup 
                    label="Story *" 
                    label-for="story-title">

                    <BFormInput 
                        id="story-title" 
                        v-model="data.title" 
                        required/>
                </BFormGroup>
            </BCol>
            <BCol md="2">
                <BFormGroup 
                    label="Story points" 
                    label-for="story-points">

                    <BFormInput 
                        id="story-points" 
                        type="number" 
                        min="0" 
                        v-model="data.points"/>
                </BFormGroup>
            </BCol>
        </BRow>

        <BFormGroup
                label="Topic"
                label-for="story-topic">

            <BFormSelect
                    id="story-topic"
                    v-model="data.topic_id">

                <option :value="null" selected>No topic</option>

                <option
                    v-for="topic in topics"
                    :value="topic.id"
                    :key="topic.id">

                    {{ topic.title }}
                </option>
            </BFormSelect>
        </BFormGroup>

        <BFormGroup 
            label="Notes" 
            label-for="story-description">

            <BFormTextarea 
                id="story-description" 
                v-model="data.description"/>
        </BFormGroup>

        <BButton 
            type="submit" 
            variant="primary"
            :class="{ 'is-disabled': isInvalid}">Save</BButton>

        <BButton 
            type="button" 
            variant="grey" 
            @click="cancel">Cancel</BButton>
    </BForm>
</template>

<script>
import { required, numeric, minValue } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BFormTextarea from '@bootstrap/form-textarea/form-textarea';
import BFormSelect from '@bootstrap/form-select/form-select';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'StoryForm',
    components: { BForm, BFormGroup, BFormInput, BFormTextarea, BFormSelect, BRow, BCol, BButton },
    extends: BaseForm,
    props: {
        project: {
            type: Object,
            default: null,
        },
    },
    computed: {
        topics() {
            return this.project
                ? this.$store.getters['topics/all'](this.project.course_id)
                : [];
        },
    },
    validations: {
        data: {
            title: { required },
            points: { numeric, minValue: minValue(0) },
        },
    },
};
</script>