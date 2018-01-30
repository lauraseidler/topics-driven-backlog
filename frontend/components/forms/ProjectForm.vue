<template>
    <BForm
        @submit.prevent="submit"
        class="project-form">

        <BFormGroup 
            label="Title" 
            label-for="project-title">

            <BFormInput 
                ref="focusInput"
                id="project-title" 
                v-model="data.title" 
                required/>
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
import { required } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'ProjectForm',
    components: { BForm, BFormGroup, BFormInput, BButton },
    extends: BaseForm,
    validations: {
        data: {
            title: { required },
        },
    },
};
</script>
