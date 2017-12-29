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
            label="Notes" 
            label-for="story-description">

            <BFormTextarea 
                id="story-description" 
                v-model="data.description"/>
        </BFormGroup>

        <BButton 
            type="submit" 
            variant="primary" 
            :disabled="isInvalid">Save</BButton>

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
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'StoryForm',
    components: { BForm, BFormGroup, BFormInput, BFormTextarea, BRow, BCol, BButton },
    extends: BaseForm,
    validations: {
        data: {
            title: { required },
            points: { numeric, minValue: minValue(0) },
        },
    },
};
</script>