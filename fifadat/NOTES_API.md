
## Endpoint reference (confirmed during investigation)

Working: `/competitions`, `/competitions/{id}`, `/competitions/search?name=`,
`/seasons?idCompetition=`, `/seasons/{id}`, `/stages?idCompetition=&idSeason=`,
`/calendar/matches?idCompetition=&idSeason=[&idStage=&idGroup=&count=]`,
`/timelines/{c}/{s}/{st}/{m}`,
`/live/football/{c}/{s}/{st}/{m}`, `/teams/{idTeam}`, `/stadiums/{idStadium}`, `/countries`,
`/confederations`, picture CDN `/picture/tournaments-{format}-{size}/{idSeason}`.

Quirks / dead ends (don't waste time re-testing): no OpenAPI/Swagger spec (spec paths return Akamai
`503`); `/calendar/standing` is dead (returns `200 null` for every competition/season/param, so no
standings tool ships); `/teams` list query → 405; `/statistics/...` and path-style `/calendar/match/...` → 404;
use `search?name=` not `?query=` (the latter returns null); `/calendar/matches` continuation cursor
doesn't advance (use a large `count`); `/live/football/...` returns `200` for any match state (a
not-started match has empty lineup/null score); season/team picture URLs are `{format}`/`{size}`
templates needing client-side resolution (`resolvePicture` defaults to `sq`/`4`; size is a 1-6
resolution tier, all valid).

```
  tool(
    "search_competitions",
    "Start here. Find a FIFA competition (the FIFA World Cup, Women's World Cup, club competitions and more) by name or fragment, e.g. 'world cup'. Returns the matching competitions, each with the string idCompetition that every other tool builds on.",
    { name: z.string().describe("Competition name or fragment, e.g. 'world cup'") },
    (a) => fifaFetch("/competitions/search", { name: a.name }, a.language),
    (p) => shape.trimCompetitionList(p),
  ),
  tool(
    "get_competition",
    "Get details for one FIFA competition by its idCompetition (name, organizer, type). Use search_competitions first if you only have the competition's name.",
    { idCompetition: z.string() },
    (a) => fetchObject(`/competitions/${seg(a.idCompetition)}`, {}, a.language),
    (p) => shape.trimCompetition(p),
  ),
  tool(
    "list_seasons",
    "List a competition's seasons/editions (e.g. each World Cup year), newest first, with start and end dates. Takes an idCompetition; returns the idSeason that stage, fixture, and squad lookups need.",
    { idCompetition: z.string(), count: z.number().int().positive().optional() },
    (a) => fifaFetch("/seasons", { idCompetition: a.idCompetition, count: a.count }, a.language),
    (p) => shape.trimSeasonList(p),
  ),
  tool(
    "get_season",
    "Get one season/edition (e.g. the 2026 FIFA World Cup) by idSeason: its dates, participating member associations, host teams, and resolved crest/logo image URLs.",
    { idSeason: z.string() },
    (a) => fetchObject(`/seasons/${seg(a.idSeason)}`, {}, a.language),
    (p) => shape.trimSeason(p),
  ),
  tool(
    "list_stages",
    "List a season's stages, e.g. Group Stage, Round of 16, Final. Takes idCompetition + idSeason; returns the idStage used to scope fixtures and match lookups.",
    { idCompetition: z.string(), idSeason: z.string() },
    (a) => fifaFetch("/stages", { idCompetition: a.idCompetition, idSeason: a.idSeason }, a.language),
    (p) => shape.trimStageList(p),
  ),
  tool(
    "list_countries",
    "List FIFA countries and member associations (reference data), each with its idCountry.",
    {},
    (a) => fifaFetch("/countries", {}, a.language),
    (p) => shape.trimCountryList(p),
  ),
  tool(
    "list_confederations",
    "List the six FIFA confederations (UEFA, CONMEBOL, CONCACAF, CAF, AFC, OFC), each with its idConfederation.",
    {},
    (a) => fifaFetch("/confederations", {}, a.language),
    (p) => shape.trimConfederationList(p),
  ),
  tool(
    "get_matches",
    "List a competition's matches: fixtures, kickoff times (UTC), and final scores for a season (e.g. every 2026 World Cup game). Takes idCompetition + idSeason; narrow with idStage/idGroup. Pagination is non-functional, so pass a large `count` for a full list; no continuation token is returned.",
    {
      idCompetition: z.string(),
      idSeason: z.string(),
      idStage: z.string().optional(),
      idGroup: z.string().optional(),
      count: z.number().int().positive().optional().describe("Max matches in one request (FIFA default 50). Set high for a full list."),
    },
    (a) =>
      fifaFetch(
        "/calendar/matches",
        { idCompetition: a.idCompetition, idSeason: a.idSeason, idStage: a.idStage, idGroup: a.idGroup, count: a.count },
        a.language,
      ),
    (p) => shape.trimMatches(p),
  ),
  tool(
    "get_match_timeline",
    "Get one match's event timeline in order: goals, cards, substitutions, and other key events. Takes idCompetition + idSeason + idStage + idMatch (idMatch comes from get_matches).",
    { idCompetition: z.string(), idSeason: z.string(), idStage: z.string(), idMatch: z.string() },
    (a) => fetchObject(`/timelines/${seg(a.idCompetition)}/${seg(a.idSeason)}/${seg(a.idStage)}/${seg(a.idMatch)}`, {}, a.language),
    (p) => shape.trimTimeline(p),
  ),
  tool(
    "get_live_match",
    "Get rich detail for one match: starting lineups, substitutes, officials, attendance, and weather, plus live score and status. Works for any match state (a not-yet-started match has an empty lineup and a null score). Takes idCompetition + idSeason + idStage + idMatch.",
    { idCompetition: z.string(), idSeason: z.string(), idStage: z.string(), idMatch: z.string() },
    (a) => fetchObject(`/live/football/${seg(a.idCompetition)}/${seg(a.idSeason)}/${seg(a.idStage)}/${seg(a.idMatch)}`, {}, a.language),
    (p) => shape.trimLiveMatch(p),
  ),
  tool(
    "get_team",
    "Get a national team or club by its idTeam: name, abbreviation, country, home city, and stadium. Surfaces idStadium so you can chain to get_stadium.",
    { idTeam: z.string() },
    (a) => fetchObject(`/teams/${seg(a.idTeam)}`, {}, a.language),
    (p) => shape.trimTeam(p),
  ),
  tool(
    "get_stadium",
    "Get a stadium/venue by its idStadium: name, city, and capacity.",
    { idStadium: z.string() },
    (a) => fetchObject(`/stadiums/${seg(a.idStadium)}`, {}, a.language),
    (p) => shape.trimStadium(p),
  ),

```
