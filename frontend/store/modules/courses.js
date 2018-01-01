import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

const resourceModule = generate({
    resource: resources.COURSES,
    children: [resources.SPRINTS, resources.PROJECTS],
});

export default resourceModule;
