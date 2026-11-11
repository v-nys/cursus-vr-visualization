// Jekyll/Rouge gebruikt een wrapper; GitHub-stijl codeblokken kunnen een klasse op code hebben.
(async () => {
  const blocks = [...document.querySelectorAll('.language-mermaid pre code, pre > code.language-mermaid')];
  if (!blocks.length) return;
  const sources = blocks.map(code => ({
    source: code.textContent,
    wrapper: code.closest('div.highlighter-rouge') || code.parentElement
  }));
  try {
    // Vaste versie, alleen geladen op pagina's die diagrammen bevatten.
    const { default: mermaid } = await import('https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.esm.min.mjs');
    mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', theme: 'default' });
    const nodes = sources.map(entry => {
      const { source, wrapper } = entry;
      const diagram = document.createElement('pre');
      diagram.className = 'mermaid';
      diagram.textContent = source;
      entry.diagram = diagram;
      wrapper.replaceWith(diagram);
      return diagram;
    });
    await mermaid.run({ nodes });
  } catch (error) {
    // De uitleg blijft leesbaar wanneer externe scripts geblokkeerd zijn.
    sources.forEach(({ source, wrapper, diagram }) => {
      const note = document.createElement('p');
      note.className = 'diagram-message';
      note.textContent = 'Het diagram kon niet worden geladen. De diagramcode staat hieronder; de uitleg staat in de tekst.';
      const fallback = document.createElement('pre');
      fallback.textContent = source;
      if (wrapper.isConnected) wrapper.replaceWith(note, fallback);
      else {
        if (diagram?.isConnected) diagram.replaceWith(note, fallback);
      }
    });
    console.warn('Mermaid kon niet worden weergegeven.', error);
  }
})();
