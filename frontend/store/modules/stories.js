import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

const resourceModule = generate({
    resource: resources.STORIES,
    parent: resources.PROJECTS,
});

export default resourceModule;
