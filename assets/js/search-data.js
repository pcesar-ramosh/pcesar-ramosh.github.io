// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "about",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-publications",
          title: "publications",
          description: "Working papers, publications and reports, newest first.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/publications/";
          },
        },{id: "nav-projects",
          title: "projects",
          description: "Research and policy projects. Each card opens a short summary with links to papers and code.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-repositories",
          title: "repositories",
          description: "Code for my research and teaching.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/repositories/";
          },
        },{id: "nav-cv",
          title: "cv",
          description: "Summary of my academic and professional record. Click the PDF icon for the full CV.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "nav-teaching",
          title: "teaching",
          description: "Courses I have taught at the graduate and undergraduate level.",
          section: "Navigation",
          handler: () => {
            window.location.href = "/teaching/";
          },
        },{id: "news-the-17th-encounter-of-economists-of-bolivia-will-be-held-in-september-at-the-universidad-san-francisco-xavier-de-chuquisaca-commemorating-its-400th-anniversary-this-prestigious-event-will-address-regional-economic-performance-amid-geopolitical-tensions-participants-can-submit-research-papers-related-to-various-economic-themes-sparkles-smile",
          title: 'The 17th Encounter of Economists of Bolivia will be held in September at...',
          description: "",
          section: "News",},{id: "news-i-was-in-tarija-bolivia-presenting-my-paper-at-the-bolivian-conference-on-development-economics",
          title: 'I was in Tarija, Bolivia, presenting my paper at the Bolivian Conference on...',
          description: "",
          section: "News",},{id: "news-são-paulo-school-of-advanced-science-on-high-dimensional-models",
          title: 'São Paulo School of Advanced Science on High-Dimensional Models',
          description: "",
          section: "News",handler: () => {
              window.location.href = "/news/announcement_2/";
            },},{id: "news-i-was-a-selected-participant-in-the-ideas-iir-advanced-student-workshop-on-development-challenges-at-the-university-of-the-west-indies-st-augustine-trinidad-and-tobago-and-took-part-in-the-ideas-iir-international-conference-on-caribbean-unorthodox-economic-thought",
          title: 'I was a selected participant in the IDEAs–IIR Advanced Student Workshop on Development...',
          description: "",
          section: "News",},{id: "news-i-started-the-m-sc-in-policy-economics-at-the-center-for-development-economics-williams-college",
          title: 'I started the M.Sc. in Policy Economics at the Center for Development Economics,...',
          description: "",
          section: "News",},{id: "projects-fiscal-policy-informality-and-wealth-distribution",
          title: 'Fiscal policy, informality and wealth distribution',
          description: "A heterogeneous-agent model of fiscal policy in economies with high informality (M.Sc. thesis)",
          section: "Projects",handler: () => {
              window.location.href = "/projects/1_fiscal_policy_informality/";
            },},{id: "projects-fiscal-vs-monetary-dominance-in-bolivia-1930-2024",
          title: 'Fiscal vs. monetary dominance in Bolivia, 1930–2024',
          description: "A historical index built from central bank reports with NLP and numerical extraction",
          section: "Projects",handler: () => {
              window.location.href = "/projects/2_fiscal_monetary_dominance/";
            },},{id: "projects-tax-policy-growth-and-inequality-in-bolivia",
          title: 'Tax policy, growth and inequality in Bolivia',
          description: "A heterogeneous-agent overlapping-generations model of labor and consumption taxes",
          section: "Projects",handler: () => {
              window.location.href = "/projects/3_tax_policy_inequality/";
            },},{id: "projects-predicting-recessions-in-bolivia-with-machine-learning",
          title: 'Predicting recessions in Bolivia with machine learning',
          description: "Logistic regression, random forests and gradient boosting as an early-warning indicator",
          section: "Projects",handler: () => {
              window.location.href = "/projects/4_recession_prediction_ml/";
            },},{id: "projects-social-registry-of-households-roadmap",
          title: 'Social Registry of Households Roadmap',
          description: "Household prioritization with Proxy Means Testing and machine learning (MEFP &amp; IDB, 2025)",
          section: "Projects",handler: () => {
              window.location.href = "/projects/5_social_registry_pmt/";
            },},{
        id: 'social-email',
        title: 'email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%70%61%75%6C%6F.%72%61%6D%6F%73.%68@%75%6E%69.%70%65", "_blank");
        },
      },{
        id: 'social-github',
        title: 'GitHub',
        section: 'Socials',
        handler: () => {
          window.open("https://github.com/pcesar-ramosh", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/pcesar-ramos", "_blank");
        },
      },{
        id: 'social-orcid',
        title: 'ORCID',
        section: 'Socials',
        handler: () => {
          window.open("https://orcid.org/0009-0009-5957-7342", "_blank");
        },
      },{
        id: 'social-rss',
        title: 'RSS Feed',
        section: 'Socials',
        handler: () => {
          window.open("/feed.xml", "_blank");
        },
      },{
        id: 'social-scholar',
        title: 'Google Scholar',
        section: 'Socials',
        handler: () => {
          window.open("https://scholar.google.com/citations?user=qc6CJjYAAAAJ", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];
