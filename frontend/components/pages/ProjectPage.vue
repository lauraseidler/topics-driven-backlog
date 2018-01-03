<template>
    <section id="project-page">
        <h2 class="h4 text-muted" v-if="course">{{ course.title}} </h2>
        <h1 v-if="project">{{ project.title }}</h1>

        <BCard no-body>
            <BTabs card v-model="tabIndex">
                <BTab title="Backlog">
                    <BacklogPage/>
                </BTab>
                <BTab title="Sprint planning">
                    <SprintPlanningPage/>
                </BTab>
                <BTab title="History">
                    <HistoryPage/>
                </BTab>
            </BTabs>
        </BCard>

    </section>
</template>

<script>
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import BacklogPage from '@/components/pages/BacklogPage';
import SprintPlanningPage from '@/components/pages/SprintPlanningPage';
import HistoryPage from '@/components/pages/HistoryPage';
import BCard from '@bootstrap/card/card';
import BTabs from '@bootstrap/tabs/tabs';
import BTab from '@bootstrap/tabs/tab';

export default {
    name: 'ProjectPage',
    extends: BaseProjectAwarePage,
    components: { BCard, BTabs, BTab, BacklogPage, SprintPlanningPage, HistoryPage },
    data() {
        return {
            tabs: ['backlog', 'sprint-planning', 'history'],
        };
    },
    computed: {
        tabIndex: {
            get: function () {
                if (this.$route.hash) {
                    const hash = this.$route.hash.substring(1);
                    return this.tabs.indexOf(hash);
                } else {
                    this.$router.replace(`${this.$route.path}#${this.tabs[0]}`);
                    return 0;
                }
            },

            set: function (newIndex) {
                this.$router.push(`${this.$route.path}#${this.tabs[newIndex]}`);
            },
        }
    }
};
</script>

<style scoped>

</style>