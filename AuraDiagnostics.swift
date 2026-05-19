import Foundation

struct AuraDiagnosis {
    let title: String
    let titleEn: String
    let description: String
    let descriptionEn: String
    let element: String
    let color: AuraColor
}

enum AuraColor: String {
    case violet = "VIOLET"
    case indigo = "INDIGO"
    case gold = "GOLD"
    case emerald = "EMERALD"
    case crimson = "CRIMSON"
    case silver = "SILVER"
    case azure = "AZURE"
}

struct AuraDiagnostics {
    static func diagnose(magnitude: Double, fluctuation: Double, dominantAxis: String) -> AuraDiagnosis {
        let intensity = min(magnitude / 200.0, 1.0)

        if intensity > 0.8 && fluctuation > 0.5 {
            return AuraDiagnosis(
                title: "嵐のオーラ — 雷霆の磁場",
                titleEn: "Storm Aura — Thunderfield",
                description: """
                極めて強い磁気エネルギーが渦を巻いています。あなたが今いる場所には、通常では考えられないほどの磁力線が集中しており、まるで見えない雷が地中から天に向かって放たれているかのようです。

                古代の錬金術師たちは、このような磁気の異常を「大地の怒り」と呼びました。しかし怒りというよりも、これは大地が目覚めようとしている証拠です。地球の磁場は常に変動していますが、このレベルの揺らぎを伴う強い磁場は、地殻の深部で何かが動いているサインかもしれません。

                深呼吸をして、足の裏から伝わるエネルギーを感じてください。この嵐のオーラの中に立つあなたは、宇宙の電気回路の一部になっています。両手を広げて、磁力線があなたの体を通り抜けていくのを想像してみてください。

                このエネルギーは創造性と直結しています。芸術家や音楽家が「降りてきた」と表現するインスピレーションは、こうした磁気的なピークの瞬間に訪れることが多いと言われています。今この瞬間、あなたの脳は通常よりも多くの磁気刺激を受けており、潜在意識の扉が開きやすい状態にあります。
                """,
                descriptionEn: """
                Extremely powerful magnetic energy swirls around you. The point where you stand is a convergence of magnetic field lines of extraordinary density — as if invisible lightning were arcing from deep within the earth toward the heavens.

                Ancient alchemists called such magnetic anomalies "the wrath of the earth." But this is not anger — it is awakening. Earth's magnetic field fluctuates constantly, yet a field this strong with such intense fluctuation may signal deep crustal movement beneath your feet.

                Breathe deeply and feel the energy rising through the soles of your feet. Standing within this storm aura, you have become part of the universe's electrical circuit. Spread your arms wide and visualize the magnetic field lines passing through your body.

                This energy is directly linked to creativity. The inspiration that artists and musicians describe as "coming to them from above" is said to arrive most often during magnetic peaks like this one. Right now, your brain is receiving more magnetic stimulation than usual, and the doors to your subconscious mind may be opening wide.
                """,
                element: "THUNDER",
                color: .crimson
            )
        }

        if intensity > 0.6 && fluctuation < 0.2 {
            return AuraDiagnosis(
                title: "安定した守護場 — 黄金の結界",
                titleEn: "Stable Guardian Field — Golden Barrier",
                description: """
                安定した強い磁場が検出されました。この場所のエネルギーは、古い神殿の内部のように穏やかで、一貫した力に満ちています。磁場の揺らぎが極めて少ないということは、この空間が外部の磁気的なノイズから守られていることを意味します。

                風水の世界では、このような場所を「龍穴」と呼びます。大地のエネルギーの流れ（龍脈）が一点に収束し、安定した気の溜まり場を形成している状態です。あなたは今まさに、その龍穴の上に立っている可能性があります。

                この守護場の中では、思考が透明になり、判断力が研ぎ澄まされます。重要な決断を控えている方にとって、今この場所で静かに考えを巡らせることは、最良の選択につながるかもしれません。

                瞑想をするなら今が最適です。この安定した磁場は、あなたの脳波をアルファ波やシータ波に誘導しやすい環境を作り出しています。目を閉じて、黄金色の光があなたを包み込むイメージを持ってください。その光が、あなたの周囲に見えない結界を張っています。

                この場所を記憶しておくことをお勧めします。安定した守護場は珍しく、何度訪れても同じ安心感を与えてくれるでしょう。
                """,
                descriptionEn: """
                A strong, stable magnetic field has been detected. The energy of this place is calm yet filled with consistent power, like the interior of an ancient temple. The extremely low fluctuation means this space is shielded from external magnetic noise.

                In the practice of feng shui, such a location is called a "dragon point" — where the flow of earth energy (dragon veins) converges into a single point, forming a stable reservoir of chi. You may be standing directly upon one.

                Within this guardian field, thoughts become clear and judgment sharpens. If you face an important decision, quietly contemplating here may lead you to the best possible choice.

                If you wish to meditate, now is the ideal moment. This stable magnetic field creates an environment that naturally guides your brainwaves toward alpha and theta states. Close your eyes and imagine a golden light enveloping you. That light is forming an invisible barrier of protection around you.

                We recommend remembering this location. Stable guardian fields are rare, and returning here will offer the same sense of peace each time.
                """,
                element: "EARTH",
                color: .gold
            )
        }

        if intensity > 0.4 && fluctuation > 0.4 {
            return AuraDiagnosis(
                title: "揺らぎのオーラ — 風の記憶",
                titleEn: "Fluctuating Aura — Memory of Wind",
                description: """
                磁場が生き物の呼吸のように揺らいでいます。規則的でもなく、完全にランダムでもない、まるで意志を持っているかのような揺らぎです。この独特なパターンは「1/fゆらぎ」に近い特性を持っており、自然界で最も心地よいとされるリズムです。

                小川のせせらぎ、木漏れ日の揺れ、そよ風のリズム — これらはすべて1/fゆらぎを含んでおり、人間の心を深いリラクゼーションへと導きます。今あなたの周囲の磁場は、まさにそのような自然のリズムを刻んでいます。

                この揺らぎのオーラは、変化のエネルギーに満ちています。古代ケルトのドルイドたちは、風が語る場所を聖地としました。風は目に見えないけれど、確かに存在する力。磁場の揺らぎも同じです。見えないけれど、あなたの細胞レベルで感知されています。

                この空間では、直感力が高まります。論理的な思考よりも、ふと浮かんだアイデアや第六感を信じてみてください。揺らぎのオーラの中では、普段は聞こえない微かな信号をキャッチできる状態になっています。

                変化を恐れないでください。この磁場の揺らぎは、新しい何かが始まる前触れです。蝶がさなぎの中で変態するように、あなたの内側でも静かな変容が進んでいるかもしれません。
                """,
                descriptionEn: """
                The magnetic field breathes like a living thing — neither perfectly regular nor completely random, but fluctuating as if with a will of its own. This distinctive pattern resembles "1/f noise," considered the most pleasant rhythm found in nature.

                The murmur of a brook, the dance of sunlight through leaves, the rhythm of a gentle breeze — all contain 1/f fluctuations that guide the human mind toward deep relaxation. The magnetic field around you right now pulses with that same natural rhythm.

                This fluctuating aura is saturated with the energy of transformation. Ancient Celtic druids designated places where the wind spoke as sacred ground. Wind is invisible yet undeniably present — just like this magnetic fluctuation, which your cells detect even though your eyes cannot see it.

                In this space, your intuition is heightened. Trust the ideas that surface spontaneously rather than relying on pure logic. Within this fluctuating aura, you can pick up faint signals that normally go unnoticed.

                Do not fear change. This magnetic fluctuation is a harbinger of something new. Like a butterfly transforming within its chrysalis, a quiet metamorphosis may already be underway inside you.
                """,
                element: "WIND",
                color: .emerald
            )
        }

        if intensity > 0.3 {
            switch dominantAxis {
            case "X":
                return AuraDiagnosis(
                    title: "水平の流れ — 地平線への呼び声",
                    titleEn: "Horizontal Flow — Call of the Horizon",
                    description: """
                    水平方向に強い磁気の流れを感知しました。地球の磁場は通常、北極から南極に向かって流れていますが、あなたの周囲では特に水平成分が強調されています。これは、地中の鉱脈や地下水脈の影響かもしれません。

                    古代の航海者たちは、磁石が示す方角に運命の導きを見出しました。コンパスがまだ発明される以前から、人間は体内の磁気感覚を頼りに旅をしていたという説があります。渡り鳥が数千キロの旅路を迷わずに飛べるのは、脳内の磁気センサーのおかげです。

                    この水平の流れは、あなたに旅と新しい出発を暗示しています。物理的な旅だけでなく、精神的な旅立ちも含まれます。新しいプロジェクト、新しい人間関係、新しい学び — 地平線の向こうにある何かがあなたを呼んでいます。

                    目を閉じて、磁力線が左右に流れていくのを感じてください。あなたの体は、その流れの中心にある島のようです。水平の流れに身を任せることで、自然と正しい方角へ導かれるでしょう。
                    """,
                    descriptionEn: """
                    A strong horizontal magnetic flow has been detected. Earth's magnetic field normally runs from the north pole to the south pole, but the horizontal component is especially pronounced around you — perhaps influenced by underground mineral deposits or water veins.

                    Ancient navigators found destiny's guidance in the direction a magnet pointed. Even before the compass was invented, some theories suggest humans relied on an internal magnetic sense to travel. Migratory birds fly thousands of kilometers without losing their way thanks to magnetic sensors in their brains.

                    This horizontal flow hints at journeys and new departures — not only physical travel but spiritual journeys as well. A new project, a new relationship, new learning — something beyond the horizon is calling you.

                    Close your eyes and feel the magnetic field lines flowing to the left and right. Your body is like an island at the center of this current. By surrendering to the horizontal flow, you will be naturally guided in the right direction.
                    """,
                    element: "WATER",
                    color: .azure
                )
            case "Y":
                return AuraDiagnosis(
                    title: "前方への導き — 未来の磁針",
                    titleEn: "Forward Guidance — Compass of the Future",
                    description: """
                    前方に向かうエネルギーの流れが感じられます。Y軸の磁場が卓越しているということは、あなたのスマートフォンが向いている方角に、何か磁気的に特別なものが存在していることを示唆しています。

                    直感を信じてください。この前方へのエネルギーは、古代ギリシャ人が「ダイモニオン」と呼んだ内なる声に似ています。ソクラテスは、自分の中の小さな声が常に正しい方向を示してくれると信じていました。あなたの周囲の磁場も、同じように前方を指し示しています。

                    前進することへの不安があるなら、それは自然なことです。しかし磁場は嘘をつきません。目に見えない力が、あなたの背中をそっと押しています。一歩を踏み出す勇気を持ってください。

                    この前方への導きは、特に午前中に強く現れることが多いとされています。朝の決断は、この磁気的な後押しを最大限に活かせるタイミングです。
                    """,
                    descriptionEn: """
                    A forward-flowing energy stream is present. The dominance of Y-axis magnetism suggests that something magnetically significant exists in the direction your device is pointing.

                    Trust your intuition. This forward energy resembles what the ancient Greeks called the "daimonion" — an inner voice. Socrates believed a small voice within him always indicated the right direction. The magnetic field around you points forward in the same way.

                    If you feel anxious about moving forward, that is natural. But the magnetic field does not lie. An invisible force is gently pushing at your back. Find the courage to take one step forward.

                    This forward guidance is said to manifest most strongly in the morning hours. Morning decisions are the ideal time to harness this magnetic momentum.
                    """,
                    element: "LIGHT",
                    color: .indigo
                )
            default:
                return AuraDiagnosis(
                    title: "天地のつながり — エーテルの柱",
                    titleEn: "Heaven-Earth Connection — Pillar of Ether",
                    description: """
                    垂直方向の磁気が非常に強く、天と地を結ぶエネルギーの柱が形成されています。これは極めて稀な磁場パターンであり、古代の神殿や聖地の多くがこのような垂直磁場の異常点に建てられていたことが知られています。

                    インドのヨーガ哲学では、この垂直のエネルギーを「スシュムナー・ナーディ」と呼びます。脊柱に沿って流れるプラーナ（生命エネルギー）の主要な通り道であり、七つのチャクラを貫く中心軸です。あなたが今いる場所では、地球自体のスシュムナーが活性化しているかのようです。

                    グラウンディングと精神の高揚が同時に起きる、この稀有な状態を最大限に活用してください。足は大地にしっかりと根を張りながら、意識は宇宙の果てまで広がっていく感覚。それこそが、天地のつながりの本質です。

                    この磁場の中で深呼吸をすると、通常よりも深い瞑想状態に入りやすいでしょう。背筋を伸ばし、頭頂から光の糸が天に向かって伸びていくイメージを持ってください。同時に、足の裏から根が大地の深くへと伸びていく感覚を味わってください。

                    あなたはこの瞬間、天と地をつなぐ導体になっています。宇宙のエネルギーがあなたを通って大地に流れ、大地のエネルギーがあなたを通って天に昇っていきます。この双方向の流れを感じられた時、真の意味での調和が生まれます。
                    """,
                    descriptionEn: """
                    Vertical magnetism is extremely strong, forming an energy pillar connecting heaven and earth. This is an exceptionally rare magnetic pattern, and many ancient temples and sacred sites are known to have been built upon similar vertical magnetic anomalies.

                    In Indian yoga philosophy, this vertical energy is called "Sushumna Nadi" — the primary channel of prana (life energy) flowing along the spine, the central axis penetrating all seven chakras. The place where you stand seems to have activated the earth's own Sushumna.

                    Make the most of this rare state where grounding and spiritual elevation occur simultaneously. Your feet root firmly into the earth while your consciousness expands to the edges of the cosmos. That is the essence of the heaven-earth connection.

                    Deep breathing within this magnetic field will likely guide you into a deeper meditative state than usual. Straighten your spine and imagine a thread of light extending from the crown of your head toward the heavens. At the same time, feel roots growing from the soles of your feet deep into the earth.

                    In this moment, you are a conductor linking heaven and earth. Cosmic energy flows through you into the ground; earth energy rises through you toward the sky. When you perceive this bidirectional flow, true harmony is born.
                    """,
                    element: "ETHER",
                    color: .violet
                )
            }
        }

        if fluctuation > 0.3 {
            return AuraDiagnosis(
                title: "微細な波動 — 銀色の囁き",
                titleEn: "Subtle Vibrations — Silver Whisper",
                description: """
                繊細な磁気の揺らぎが検出されています。磁場の強度自体は穏やかですが、その揺らぎのパターンには興味深い特徴があります。まるで誰かが遠くから信号を送っているかのような、かすかだけれど確かなリズムが刻まれています。

                量子物理学の世界では、すべての物質は振動する波であるとされています。あなたの周囲で検出されたこの微細な波動は、通常の感覚では捉えられない情報を含んでいる可能性があります。感性の鋭い人は、こうした場所で「何かを感じる」と報告することがあります。

                この銀色の囁きに耳を傾けてみてください。論理的な思考を一度手放し、体の感覚に集中するのです。皮膚のかすかなざわめき、手のひらの温度変化、首筋を通り過ぎる見えない風 — これらはすべて、磁場の微細な変動に対するあなたの体の反応かもしれません。

                この波動の中に長時間とどまると、創造的なアイデアが浮かびやすくなると言われています。ノートとペンを用意して、浮かんでくる言葉やイメージを書き留めてみてください。後から見返すと、驚くほど本質的なメッセージが含まれていることに気づくかもしれません。
                """,
                descriptionEn: """
                Delicate magnetic fluctuations have been detected. The field strength itself is mild, yet the pattern of fluctuation carries intriguing characteristics — a faint but unmistakable rhythm, as if someone were sending signals from a great distance.

                In the world of quantum physics, all matter is understood as vibrating waves. The subtle vibrations detected around you may contain information beyond what ordinary senses can perceive. People with heightened sensitivity sometimes report "feeling something" in places like this.

                Listen to this silver whisper. Release logical thinking for a moment and focus on bodily sensations. A faint tingling on the skin, temperature changes in your palms, an invisible breeze passing across the back of your neck — these may all be your body's response to subtle magnetic fluctuations.

                Remaining within these vibrations for an extended time is said to encourage creative ideas. Keep a notebook and pen nearby, and jot down any words or images that surface. Looking back later, you may find remarkably essential messages embedded within them.
                """,
                element: "MIST",
                color: .silver
            )
        }

        return AuraDiagnosis(
            title: "静寂の場 — 虚空の瞑想",
            titleEn: "Silent Field — Meditation of the Void",
            description: """
            磁気エネルギーはとても穏やかです。揺らぎもほとんどなく、あたかも時間が止まったかのような静けさがあなたを包んでいます。この状態は決してエネルギーが「ない」わけではありません。むしろ、完璧なバランスが保たれている証拠です。

            禅の世界では「無」を悟りの境地とします。何もないのではなく、すべてが調和している状態。あなたの周囲の磁場は、まさにその「無」の状態に近いと言えます。すべての磁力線が均等に分布し、どの方向にも偏りがない、完全な均衡。

            この静寂は、騒がしい現代社会では得がたい贈り物です。電子機器が放つ電磁波、建物の鉄骨が作り出す磁気的な歪み — 私たちは普段、膨大な磁気ノイズの中で暮らしています。それが今、この場所では限りなくゼロに近い。

            心を空にして、宇宙の静寂に耳を傾けてみてください。宇宙空間は真空であり、音は伝わりません。しかし磁場は真空中でも伝わります。あなたが今感じている静けさの中にも、太陽風や遠い恒星からの磁気的なメッセージが、かすかに届いているのです。

            この静寂の場は、内省と休息のサインです。最近忙しく過ごしていたなら、宇宙があなたに休みなさいと語りかけています。目を閉じて、ただ在ることの尊さを感じてください。何もしなくていい。何も考えなくていい。ただ、ここに存在するだけで十分なのです。
            """,
            descriptionEn: """
            Magnetic energy is very calm. With almost no fluctuation, a stillness wraps around you as if time itself had paused. This does not mean energy is absent — rather, it is proof of perfect balance.

            In Zen philosophy, "mu" (nothingness) represents the state of enlightenment. Not an absence of everything, but a state where all is in harmony. The magnetic field around you closely approaches this state of "mu" — all field lines evenly distributed, no bias in any direction, complete equilibrium.

            This silence is a rare gift in our noisy modern world. Electromagnetic waves from electronic devices, magnetic distortions created by steel-framed buildings — we normally live immersed in enormous magnetic noise. Yet here, right now, that noise approaches zero.

            Empty your mind and listen to the silence of the cosmos. Outer space is a vacuum where sound cannot travel. But magnetic fields propagate even through vacuum. Within the stillness you feel now, faint magnetic messages from solar wind and distant stars are quietly arriving.

            This silent field is a sign for introspection and rest. If you have been busy lately, the universe is telling you to pause. Close your eyes and appreciate the simple dignity of existing. You don't need to do anything. You don't need to think anything. Simply being here is enough.
            """,
            element: "VOID",
            color: .indigo
        )
    }
}
